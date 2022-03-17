import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:error_repository/error_repository.dart';
import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';

class OpenProductionDataRepository {

  OpenProductionDataRepository({
    required AuthenticatedHttpClient authenticatedHttpClient, 
    required TenantInformation tenantInformation,
    required ErrorRepository errorRepository
  }) : 
    _authHttpClient = authenticatedHttpClient,
    _tenantInformation = tenantInformation,
    _errorRepository = errorRepository;

  final ErrorRepository _errorRepository;
  final AuthenticatedHttpClient _authHttpClient;
  final TenantInformation _tenantInformation;

  final Map<int, ProductionBasicData> _openDataList = new Map();

  final _openDataStreamController = StreamController<List<ProductionBasicData>>.broadcast();
  final _productionDataStreamController = new Map<int, StreamController<ProductionBasicData>>();

  ProductionBasicData _getProductionBasicData(int id) {
    var prdData = _openDataList[id];
    if (prdData == null) {
      throw new Exception("Stream not found");
    } else {
      return prdData;
    }
  }

  Stream<List<ProductionBasicData>> openDataStream() async* {
    yield _openDataList.values.toList();
    yield* _openDataStreamController.stream;
  }

  Stream<ProductionBasicData> productionDataStream(int id) async* {
    var streamController = _productionDataStreamController[id];
    if (streamController != null) {
      yield _getProductionBasicData(id);
      yield* streamController.stream;
    } else {
      throw new Exception("Stream not found");
    }
  }

  Future<void> cancelProductionData(int id) async {
    await _authHttpClient.patchCancelProductionDataById(id);

    if (_openDataList.containsKey(id)) {
      _openDataList.removeWhere((key, value) => key == id);
    }

    if (_productionDataStreamController.containsKey(id)){
      await _productionDataStreamController[id]!.close();
      _productionDataStreamController.removeWhere((key, value) => key == id);
    }

    if (_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openDataList.values.toList());
    }
  
  }

  Future<void> loadProductionData(int id) async {
    var response = await _authHttpClient.getProductionDataById(id);
    var productionBasicData = ProductionBasicData.fromJson(response.data[0], _tenantInformation.location);
    _openDataList[productionBasicData.id] = productionBasicData;

    if (_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openDataList.values.toList());
    }
    _productionDataStreamController[productionBasicData.id] = StreamController<ProductionBasicData>.broadcast();
  }

  // TODO create FIFO queue
  Future _updateBeginApi(ProductionBasicData productionBasicData) async {
    try {
      await _authHttpClient.patchProductionDataBegin(productionBasicData, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    }
  }

  Future _updateEndApi(ProductionBasicData productionBasicData) async {
    try {
      await _authHttpClient.patchProductionDataEnd(productionBasicData, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    }
  }

  Future _updateCommentsApi(ProductionBasicData productionBasicData) async {
    try {
      await _authHttpClient.patchProductionDataComments(productionBasicData, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    }
  }

  Future _updateProductApi(ProductionBasicData productionBasicData) async {
    try {
      await _authHttpClient.patchProductionDataProduct(productionBasicData, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    }
  }

  Future _updateVariableApi(ProductionVariable variable) async {
    try {
      await _authHttpClient.patchProductionVariable(variable);
    } catch (e) {
      _errorRepository.communicateError(e);
    }
  }

  updateBegin(int id, DateTime? begin) {
    var prdData = _getProductionBasicData(id);
    if (prdData.begin != begin) {
      prdData = prdData.copyWith(begin: begin);
      emitProductionChange(id, prdData);
      unawaited(_updateBeginApi(prdData));
    }
  }

  updateEnd(int id, DateTime? end) {
    var prdData = _getProductionBasicData(id);
    if (prdData.end != end) {
      prdData = prdData.copyWith(end: end);
      emitProductionChange(id, prdData);
      unawaited(_updateEndApi(prdData));
    }
  }

  updateComments(int id, String? comments) {
    var prdData = _getProductionBasicData(id);
    if ((prdData.comments?.trim() ?? "") != (comments?.trim() ?? "")) {
      prdData = prdData.copyWith(comments: comments);
      emitProductionChange(id, prdData);
      EasyDebounce.debounce(id.toString() + '-update-comments', Duration(seconds: 1), () => unawaited(_updateCommentsApi(prdData)));
    }
  }

  updateProduct(int id, int? productId) {
    var prdData = _getProductionBasicData(id);
    if (prdData.productId != productId) {
      prdData = prdData.copyWith(productId: productId);
      emitProductionChange(id, prdData);
      unawaited(_updateProductApi(prdData));
    }
  }

  updateVariableNumeric(int id, int variableId, double? newValue) {
    var prdData = _getProductionBasicData(id);

    ProductionLineUnit? productionLineUnit;
    int? productionLineUnitIndex;
    ProductionVariable? productionVariable;
    int? productionVariableIndex;

    prdData.lineUnits.asMap().forEach((indexProductionLineUnit, lineUnit) {
      lineUnit.lineUnit.productionVariables.asMap().forEach((indexVariable, variable) {
        if (variable.id == variableId) {
          productionLineUnit = lineUnit;
          productionLineUnitIndex = indexProductionLineUnit;
          productionVariable = variable;
          productionVariableIndex = indexVariable;
        }
      });
    });

    if (productionLineUnit != null && productionVariable != null) {
      if (productionVariable!.value != newValue) {
        var newVariable = productionVariable!.copyWith(value: newValue);

        var newVariablesList = productionLineUnit!.lineUnit.productionVariables.toList();
        newVariablesList[productionVariableIndex!] = newVariable;

        var newLineUnit = productionLineUnit!.lineUnit.copyWith(productionVariables: newVariablesList);
        var newProcutionLineUnit = productionLineUnit!.copyWith(lineUnit: newLineUnit);

        var newProcutionLineUnitList = prdData.lineUnits.toList();
        newProcutionLineUnitList[productionLineUnitIndex!] = newProcutionLineUnit;

        prdData = prdData.copyWith(lineUnits: newProcutionLineUnitList);
        emitProductionChange(id, prdData);
        EasyDebounce.debounce(id.toString() + '-update-variable-' + variableId.toString(), Duration(seconds: 2), () => unawaited(_updateVariableApi(newVariable)));
      }
    }
  }

  updateVariableText(int id, int variableId, String? newValue) {
    var prdData = _getProductionBasicData(id);

    ProductionLineUnit? productionLineUnit;
    int? productionLineUnitIndex;
    ProductionVariable? productionVariable;
    int? productionVariableIndex;

    prdData.lineUnits.asMap().forEach((indexProductionLineUnit, lineUnit) {
      lineUnit.lineUnit.productionVariables.asMap().forEach((indexVariable, variable) {
        if (variable.id == variableId) {
          productionLineUnit = lineUnit;
          productionLineUnitIndex = indexProductionLineUnit;
          productionVariable = variable;
          productionVariableIndex = indexVariable;
        }
      });
    });

    if (productionLineUnit != null && productionVariable != null) {
      if (productionVariable!.value != newValue) {
        var newVariable = productionVariable!.copyWith(text: newValue);

        var newVariablesList = productionLineUnit!.lineUnit.productionVariables.toList();
        newVariablesList[productionVariableIndex!] = newVariable;

        var newLineUnit = productionLineUnit!.lineUnit.copyWith(productionVariables: newVariablesList);
        var newProcutionLineUnit = productionLineUnit!.copyWith(lineUnit: newLineUnit);

        var newProcutionLineUnitList = prdData.lineUnits.toList();
        newProcutionLineUnitList[productionLineUnitIndex!] = newProcutionLineUnit;

        prdData = prdData.copyWith(lineUnits: newProcutionLineUnitList);
        emitProductionChange(id, prdData);
        EasyDebounce.debounce(id.toString() + '-updateVariable-' + variableId.toString(), Duration(seconds: 2), () => unawaited(_updateVariableApi(newVariable)));
      }
    }
  }

  Future<void> addLoss(int productionBasicDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId) async {
    var response = await _authHttpClient.postProductionLoss(productionBasicDataId, lossCurrentDefinitionId, lossValue, lineUnitId);
    var newLosses = response.data.map((x) => ProductionLoss.fromJson(x)).cast<ProductionLoss>().toList();
    var prdData = _getProductionBasicData(productionBasicDataId);
    var oldLosses = prdData.losses; 
    var allLosses = List<ProductionLoss>.from(oldLosses)..addAll(newLosses);
    emitProductionChange(productionBasicDataId, prdData.copyWith(losses: allLosses));

  }

  Future<void> deleteLoss(int productionBasicDataId, int productionLossId) async {
    await _authHttpClient.deleteProductionLoss(productionLossId);
    var prdData = _getProductionBasicData(productionBasicDataId);
    var filteredLosses = prdData.losses.where((e) => e.id != productionLossId).toList(); 
    emitProductionChange(productionBasicDataId, prdData.copyWith(losses: filteredLosses));
  }

  Future<void> addStop({
    required int productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId,
    required StopTypeOf stopType,
    required List<StopClaim> claims, 
    double? averageTimeAtStopQtyAverageTime, 
    int? qtyAtStopQtyAverageTime,
    DateTime? beginAtStopBeginAndTimeSpan,
    double? timeSpanAtStopBeginAndTimeSpan,
    DateTime? beginAtStopBeginEnd,
    DateTime? endAtStopBeginEnd,
    int? qtyAtStopQtyTotalTime,
    double? totalTimeAtStopQtyTotalTime,
    double? stopTimeAtStopTimePerStop
  }) async {

    var response = await _authHttpClient.postProductionStop(
      location: _tenantInformation.location,
      productionBasicDataId: productionBasicDataId,
      lineUnitId: lineUnitId,
      stopCurrentDefinitionId: stopCurrentDefinitionId,
      stopType: stopType,
      claims: claims,
      averageTimeAtStopQtyAverageTime: averageTimeAtStopQtyAverageTime,
      qtyAtStopQtyAverageTime: qtyAtStopQtyAverageTime,
      beginAtStopBeginAndTimeSpan: beginAtStopBeginAndTimeSpan,
      timeSpanAtStopBeginAndTimeSpan: timeSpanAtStopBeginAndTimeSpan,
      beginAtStopBeginEnd: beginAtStopBeginEnd,
      endAtStopBeginEnd: endAtStopBeginEnd,
      qtyAtStopQtyTotalTime: qtyAtStopQtyTotalTime,
      totalTimeAtStopQtyTotalTime: totalTimeAtStopQtyTotalTime,
      stopTimeAtStopTimePerStop: stopTimeAtStopTimePerStop,
    );
    var newStops = response.data.map((x) => ProductionStop.fromJson(x, _tenantInformation.location)).cast<ProductionStop>().toList();
    var prdData = _getProductionBasicData(productionBasicDataId);
    var oldStops = prdData.stops; 
    var allStops = List<ProductionStop>.from(oldStops)..addAll(newStops);
    emitProductionChange(productionBasicDataId, prdData.copyWith(stops: allStops));
  }

  Future<void> deleteStop(int productionBasicDataId, int productionStopId) async {
    await _authHttpClient.deleteProductionStop(productionStopId);
    var prdData = _getProductionBasicData(productionBasicDataId);
    var filteredStops = prdData.stops.where((e) => e.id != productionStopId).toList(); 
    emitProductionChange(productionBasicDataId, prdData.copyWith(stops: filteredStops));
  }


  void emitProductionChange(int id, ProductionBasicData prdData) {
    _openDataList[id] = prdData;

    if (_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openDataList.values.toList());
    }
    
    var productionDataStreamController = _productionDataStreamController[id];
    if (productionDataStreamController != null && productionDataStreamController.hasListener) {
      productionDataStreamController.add(prdData);
    }

  }

  void closeProductionData(int id) {
    _openDataList.remove(id);
    _openDataStreamController.add(_openDataList.values.toList());
    _productionDataStreamController[id]?.close();
    _productionDataStreamController.remove(id);
  }

  void dispose() {
    _openDataStreamController.close();
    _productionDataStreamController.forEach((key, value) => value.close());
  }
    

}