import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';

class OpenProductionDataRepository {

  OpenProductionDataRepository(this._http, this._tenantInformation);

  final AuthenticatedHttpClient _http;
  final TenantInformation _tenantInformation;

  final Map<int, ProductionBasicData> _openDataList = new Map();

  final _errorsDataStreamController = StreamController<String>.broadcast();
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

  Future<void> loadProductionData(int id) async {
    var response = await _http.getProductionDataById(id);
    var productionBasicData = ProductionBasicData.fromJson(response.data[0], _tenantInformation.timeZone);
    _openDataList[productionBasicData.id] = productionBasicData;

    if(_openDataStreamController.hasListener) {
      _openDataStreamController.add(_openDataList.values.toList());
    }
    _productionDataStreamController[productionBasicData.id] = StreamController<ProductionBasicData>.broadcast();
  }

  // TODO create FIFO queue
  Future _updateBeginApi(ProductionBasicData productionBasicData) async {
    try {
      await _http.patchProductionDataBegin(productionBasicData);
    } catch (e) {
      _errorsDataStreamController.add(e.toString());
    }
  }

  Future _updateEndApi(ProductionBasicData productionBasicData) async {
    try {
      await _http.patchProductionDataEnd(productionBasicData);
    } catch (e) {
      _errorsDataStreamController.add(e.toString());
    }
  }

  Future _updateCommentApis(ProductionBasicData productionBasicData) async {
    try {
      await _http.patchProductionDataComments(productionBasicData);
    } catch (e) {
      _errorsDataStreamController.add(e.toString());
    }
  }

  Future _updateProductApis(ProductionBasicData productionBasicData) async {
    try {
      await _http.patchProductionDataProduct(productionBasicData);
    } catch (e) {
      _errorsDataStreamController.add(e.toString());
    }
  }

  updateBegin(int id, DateTime? begin) {
    var prdData = _getProductionBasicData(id);
    if (prdData.begin != begin) {
      prdData = prdData.copyWith(begin: begin);
      emitProductionChange(id, prdData);
      _updateBeginApi(prdData);
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
      EasyDebounce.debounce('updateComments', Duration(seconds: 2), () => unawaited(_updateCommentApis(prdData)));
    }
  }

  updateProduct(int id, int? productId) {
    var prdData = _getProductionBasicData(id);
    if (prdData.productId != productId) {
      prdData = prdData.copyWith(productId: productId);
      emitProductionChange(id, prdData);
      unawaited(_updateProductApis(prdData));
    }
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
  }

  void dispose() {
    _openDataStreamController.close();
    _productionDataStreamController.forEach((key, value) => value.close());
  }
    

}