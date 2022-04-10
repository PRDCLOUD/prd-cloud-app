import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:error_repository/error_repository.dart';
import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

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

  final Set<String> _pendingHttpRequests = Set();
  final _pendingHttpRequestsStreamController = StreamController<List<String>>.broadcast();

  final _lastLoadedProductionGroupController = StreamController<int?>.broadcast();

  final Map<int, ProductionDataGroup> _openProductionGroup = new Map();
  final _openDataStreamController = StreamController<List<ProductionDataGroup>>.broadcast();


  final Map<int, ProductionData> _openProductionDataList = new Map();
  final _productionDataStreamController = new Map<int, StreamController<ProductionData>>();

  ProductionDataGroup _getProductionGroupData(int productionDataId) {
    var group = _openProductionGroup.values.firstWhere((group) => group.productionDataGroup.any((productionData) => productionData.id == productionDataId));
    return group;
  }

  ProductionData _getProductionBasicData(int id) {
    var prdData = _openProductionDataList[id];
    if (prdData == null) {
      throw new Exception("Stream not found");
    } else {
      return prdData;
    }
  }

  Stream<List<String>> pendingHttpRequestsStream() async* {
    yield _pendingHttpRequests.toList();
    yield* _pendingHttpRequestsStreamController.stream;
  }

  Stream<List<ProductionDataGroup>> openDataStream() async* {
    yield _openProductionGroup.values.toList();
    yield* _openDataStreamController.stream;
  }

  Stream<int?> lastLoadedStream() async* {
    yield null;
    yield* _lastLoadedProductionGroupController.stream;
  }

  Stream<ProductionData> productionDataStream(int id) async* {
    var streamController = _productionDataStreamController[id];
    if (streamController != null) {
      yield _getProductionBasicData(id);
      yield* streamController.stream;
    } else {
      throw new Exception("Stream not found");
    }
  }

  Future<void> openNewProductionData(List<ProductionLineAndGroup> productionLineAndGroups) async {
    var openedItems = List<ProductionDataGroup>.empty(growable: true);
    
    var requestId = startHttpRequestMark();
    try {
      for (var item in productionLineAndGroups) {
        var productionId = await _authHttpClient.postOpenInputProductionData(item.id, item.isGroup());
        var response = await _authHttpClient.getProductionDataById(productionId);
        var productionBasicData = response.data.map((e) => ProductionData.fromJson(e, _tenantInformation.location)).cast<ProductionData>().toList() as List<ProductionData>;
        openedItems.add(ProductionDataGroup(productionBasicData));
      }
    } finally {
      endHttpRequestMark(requestId);
    }

    for (var openedItem in openedItems) {

      _openProductionGroup[openedItem.getId()] = openedItem;

      for (var productionData in openedItem.productionDataGroup) {
        _openProductionDataList[productionData.id] = productionData;
        _productionDataStreamController[productionData.id] = StreamController<ProductionData>.broadcast();
      }
    }

    if (_lastLoadedProductionGroupController.hasListener) {
      _lastLoadedProductionGroupController.add(openedItems.last.getId());
    }

    if (_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openProductionGroup.values.toList());
    }

  }

  Future<void> concludeProductionData(ProductionDataGroup productionDataGroup) async {

    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.patchConcludeProduction(productionDataGroup, _tenantInformation.location);
    } finally {
      endHttpRequestMark(requestId);
    }

    if (_openProductionGroup.containsKey(productionDataGroup.getId())) {
      _openProductionGroup.remove(productionDataGroup.getId());
    }

    for (var item in productionDataGroup.productionDataGroup) {
      _openProductionDataList.remove(item.id);
      if (_productionDataStreamController.containsKey(item.id)){
        await _productionDataStreamController[item.id]!.close();
        _productionDataStreamController.remove(item.id);
      }
    }

    if (_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openProductionGroup.values.toList());
    }
  }

  Future<void> cancelProductionData(int id) async {

    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.patchCancelProductionDataById(id);
    } finally {
      endHttpRequestMark(requestId);
    }
    var productionGroup = _getProductionGroupData(id);

    if (_openProductionGroup.containsKey(productionGroup.getId())) {
      _openProductionGroup.remove(productionGroup.getId());
    }

    for (var item in productionGroup.productionDataGroup) {
      _openProductionDataList.remove(item.id);
      if (_productionDataStreamController.containsKey(item.id)){
        await _productionDataStreamController[item.id]!.close();
        _productionDataStreamController.remove(item.id);
      }
    }

    if (_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openProductionGroup.values.toList());
    }
  
  }

  Future<void> loadProductionData(int id) async {

    var requestId = startHttpRequestMark();
    try {
      var response = await _authHttpClient.getProductionDataById(id);

      var productionBasicData = response.data.map((e) => ProductionData.fromJson(e, _tenantInformation.location)).cast<ProductionData>().toList() as List<ProductionData>;
      var group = ProductionDataGroup(productionBasicData);

      _openProductionGroup[group.getId()] = group;

      for (var productionData in group.productionDataGroup) {
        _openProductionDataList[productionData.id] = productionData;
        _productionDataStreamController[productionData.id] = StreamController<ProductionData>.broadcast();
      }

      if (_openDataStreamController.hasListener) {
        _openDataStreamController.add(_openProductionGroup.values.toList());
      }

      if (_lastLoadedProductionGroupController.hasListener) {
        _lastLoadedProductionGroupController.add(group.getId());
      }
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future _updateBeginApi(ProductionData productionBasicData) async {
    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.patchProductionDataBegin(productionBasicData, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future _updateEndApi(ProductionData productionBasicData) async {
    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.patchProductionDataEnd(productionBasicData, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future _updateCommentsApi(ProductionData productionBasicData) async {
    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.patchProductionDataComments(productionBasicData, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future _updateProductApi(ProductionData productionBasicData) async {
    var requestId = startHttpRequestMark();
    try {
      var result = await _authHttpClient.patchProductionDataProduct(productionBasicData, _tenantInformation.location);
      if (result.data != null && result.data is List<dynamic>) {
        for (var newVariableValue in result.data) {
          if (newVariableValue['typeVariableDefinition'] == "Numeric") {
            updateVariableNumeric(newVariableValue['productionBasicDataId'], newVariableValue['id'], newVariableValue['value']);
          } else if (newVariableValue['typeVariableDefinition'] == "Text") {
            updateVariableText(newVariableValue['productionBasicDataId'], newVariableValue['id'], newVariableValue['text']);
          }
        }
      }
    } catch (e) {
      _errorRepository.communicateError(e);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future _updateVariableApi(ProductionVariable variable) async {
    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.patchProductionVariable(variable, _tenantInformation.location);
    } catch (e) {
      _errorRepository.communicateError(e);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  updateBegin(int id, DateTime? begin) {
    var prdDataGroup = _getProductionGroupData(id);
    var newPrdDataGroup = prdDataGroup.copyWithBegin(begin);
    emitProductionChanges(newPrdDataGroup);
    unawaited(_updateBeginApi(newPrdDataGroup.productionDataGroup.firstWhere((e) => e.id == id)));
  }

  updateEnd(int id, DateTime? end) {
    var prdDataGroup = _getProductionGroupData(id);
    var newPrdDataGroup = prdDataGroup.copyWithEnd(end);
    emitProductionChanges(newPrdDataGroup);
    unawaited(_updateEndApi(newPrdDataGroup.productionDataGroup.firstWhere((e) => e.id == id)));
  }

  updateComments(int id, String? comments) {
    var prdDataGroup = _getProductionGroupData(id);
    var newPrdDataGroup = prdDataGroup.copyWithComments(comments);
    emitProductionChanges(newPrdDataGroup);

    var requestId = startHttpRequestMark();
    try {     
      EasyDebounce.debounce(id.toString() + '-comments', Duration(seconds: 2), () => unawaited(_updateCommentsApi(newPrdDataGroup.productionDataGroup.firstWhere((e) => e.id == id))));
    } finally {
      EasyDebounce.debounce(requestId, Duration(seconds: 2), () => endHttpRequestMark(requestId));
    }
  }

  updateProduct(int id, int? productId) {
    var prdDataGroup = _getProductionGroupData(id);
    var newPrdDataGroup = prdDataGroup.copyWithProductId(id, productId);
    emitProductionChanges(newPrdDataGroup);
    unawaited(_updateProductApi(newPrdDataGroup.productionDataGroup.firstWhere((e) => e.id == id)));
  }

  updateVariableNumeric(int productionDataId, int variableId, double? newValue) {
    var prdData = _getProductionBasicData(productionDataId);

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
        var newVariable = productionVariable!.copyWith(value: Optional.value(newValue));

        var newVariablesList = productionLineUnit!.lineUnit.productionVariables.toList();
        newVariablesList[productionVariableIndex!] = newVariable;

        var newLineUnit = productionLineUnit!.lineUnit.copyWithNewVariables(productionVariables: newVariablesList);
        var newProcutionLineUnit = productionLineUnit!.copyWith(lineUnit: newLineUnit);

        var newProcutionLineUnitList = prdData.lineUnits.toList();
        newProcutionLineUnitList[productionLineUnitIndex!] = newProcutionLineUnit;

        var newPrdData = prdData.copyWith(lineUnits: newProcutionLineUnitList);

        var prdGroup = _getProductionGroupData(productionDataId);
        var newPrdGroup = prdGroup.copyWithProductionData(newPrdData);

        emitProductionChanges(newPrdGroup);

        if (!newVariable.isReadOnly) {
          var requestId = startHttpRequestMark();
          try {     
            EasyDebounce.debounce(productionDataId.toString() + '-update-variable-' + variableId.toString(), Duration(seconds: 2), () => unawaited(_updateVariableApi(newVariable)));
          } finally {
            EasyDebounce.debounce(requestId, Duration(seconds: 2), () => endHttpRequestMark(requestId));
          }
        }
      }
    }
  }

  updateVariableText(int productionDataId, int variableId, String? newValue) {
    var prdData = _getProductionBasicData(productionDataId);

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
        var newVariable = productionVariable!.copyWith(text: Optional.value(newValue));

        var newVariablesList = productionLineUnit!.lineUnit.productionVariables.toList();
        newVariablesList[productionVariableIndex!] = newVariable;

        var newLineUnit = productionLineUnit!.lineUnit.copyWithNewVariables(productionVariables: newVariablesList);
        var newProcutionLineUnit = productionLineUnit!.copyWith(lineUnit: newLineUnit);

        var newProcutionLineUnitList = prdData.lineUnits.toList();
        newProcutionLineUnitList[productionLineUnitIndex!] = newProcutionLineUnit;

        var newPrdData = prdData.copyWith(lineUnits: newProcutionLineUnitList);

        var prdGroup = _getProductionGroupData(productionDataId);
        var newPrdGroup = prdGroup.copyWithProductionData(newPrdData);

        emitProductionChanges(newPrdGroup);
        
        if (!newVariable.isReadOnly) {
          var requestId = startHttpRequestMark();
          try {     
            EasyDebounce.debounce(productionDataId.toString() + '-update-variable-' + variableId.toString(), Duration(seconds: 2), () => unawaited(_updateVariableApi(newVariable)));
          } finally {
            EasyDebounce.debounce(requestId, Duration(seconds: 2), () => endHttpRequestMark(requestId));
          }
        }
      }
    }
  }

  updateVariableDateTime(int productionDataId, int variableId, DateTime? newValue) {
    var prdData = _getProductionBasicData(productionDataId);

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
        var newVariable = productionVariable!.copyWith(dateTime: Optional.value(newValue));

        var newVariablesList = productionLineUnit!.lineUnit.productionVariables.toList();
        newVariablesList[productionVariableIndex!] = newVariable;

        var newLineUnit = productionLineUnit!.lineUnit.copyWithNewVariables(productionVariables: newVariablesList);
        var newProcutionLineUnit = productionLineUnit!.copyWith(lineUnit: newLineUnit);

        var newProcutionLineUnitList = prdData.lineUnits.toList();
        newProcutionLineUnitList[productionLineUnitIndex!] = newProcutionLineUnit;

        var newPrdData = prdData.copyWith(lineUnits: newProcutionLineUnitList);

        var prdGroup = _getProductionGroupData(productionDataId);
        var newPrdGroup = prdGroup.copyWithProductionData(newPrdData);

        emitProductionChanges(newPrdGroup);
        
        if (!newVariable.isReadOnly) {
          var requestId = startHttpRequestMark();
          try {     
            EasyDebounce.debounce(productionDataId.toString() + '-update-variable-' + variableId.toString(), Duration(seconds: 2), () => unawaited(_updateVariableApi(newVariable)));
          } finally {
            EasyDebounce.debounce(requestId, Duration(seconds: 2), () => endHttpRequestMark(requestId));
          }
        }
      }
    }
  }

  Future<void> addLoss(int productionDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId) async {
    var requestId = startHttpRequestMark();
    try {
      var response = await _authHttpClient.postProductionLoss(productionDataId, lossCurrentDefinitionId, lossValue, lineUnitId);
      var newLosses = response.data.map((x) => ProductionLoss.fromJson(x)).cast<ProductionLoss>().toList();
      var prdData = _getProductionBasicData(productionDataId);
      var oldLosses = prdData.losses; 
      var allLosses = List<ProductionLoss>.from(oldLosses)..addAll(newLosses);
      var newPrdData = prdData.copyWith(losses: allLosses);

      var prdGroup = _getProductionGroupData(productionDataId);
      var newPrdGroup = prdGroup.copyWithProductionData(newPrdData);
      emitProductionChanges(newPrdGroup);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future<void> deleteLoss(int productionDataId, int productionLossId) async {
    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.deleteProductionLoss(productionLossId);
      var prdData = _getProductionBasicData(productionDataId);
      var filteredLosses = prdData.losses.where((e) => e.id != productionLossId).toList(); 
      var newPrdData = prdData.copyWith(losses: filteredLosses);
      var prdGroup = _getProductionGroupData(productionDataId);
      var newPrdGroup = prdGroup.copyWithProductionData(newPrdData);
      emitProductionChanges(newPrdGroup);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future<void> addStop({
    required int productionDataId, 
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
    var requestId = startHttpRequestMark();
    try {
      var response = await _authHttpClient.postProductionStop(
        location: _tenantInformation.location,
        productionBasicDataId: productionDataId,
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
      var prdData = _getProductionBasicData(productionDataId);
      var oldStops = prdData.stops; 
      var allStops = List<ProductionStop>.from(oldStops)..addAll(newStops);
      var newPrdData = prdData.copyWith(stops: allStops);

      var prdGroup = _getProductionGroupData(productionDataId);
      var newPrdGroup = prdGroup.copyWithProductionData(newPrdData);
      emitProductionChanges(newPrdGroup);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  Future<void> deleteStop(int productionDataId, int productionStopId) async {
    var requestId = startHttpRequestMark();
    try {
      await _authHttpClient.deleteProductionStop(productionStopId);
      var prdData = _getProductionBasicData(productionDataId);
      var filteredStops = prdData.stops.where((e) => e.id != productionStopId).toList(); 

      var newPrdData = prdData.copyWith(stops: filteredStops);

      var prdGroup = _getProductionGroupData(productionDataId);
      var newPrdGroup = prdGroup.copyWithProductionData(newPrdData);
      emitProductionChanges(newPrdGroup);
    } finally {
      endHttpRequestMark(requestId);
    }
  }

  void emitProductionChanges(ProductionDataGroup productionDataGroup) {

    _openProductionGroup[productionDataGroup.getId()] = productionDataGroup;

    for (var item in productionDataGroup.productionDataGroup) {
      _openProductionDataList[item.id] = item;

      var productionDataStreamController = _productionDataStreamController[item.id];
      if (productionDataStreamController != null && productionDataStreamController.hasListener) {
        productionDataStreamController.add(item);
      }
    }

    if (_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openProductionGroup.values.toList());
    }
  
  }

  void closeProductionData(int productionDataId) {
    var group = _getProductionGroupData(productionDataId);
    _openProductionGroup.remove(group.getId());
    _openDataStreamController.add(_openProductionGroup.values.toList());

    for (var item in group.productionDataGroup) {
      _productionDataStreamController[item.id]?.close();
      _productionDataStreamController.remove(item.id);
    }
  }

  String startHttpRequestMark() {
    var uid = Uuid().v1().toString();
    _pendingHttpRequests.add(uid);
    _pendingHttpRequestsStreamController.add(_pendingHttpRequests.toList());
    return uid;
  }

  void endHttpRequestMark(String requestId) {
    _pendingHttpRequests.remove(requestId);
    _pendingHttpRequestsStreamController.add(_pendingHttpRequests.toList());
  }

  void dispose() {
    _openDataStreamController.close();
    _pendingHttpRequestsStreamController.close();
    _productionDataStreamController.forEach((key, value) => value.close());
  }
    

}