import 'dart:async';

import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';

class OpenProductionDataRepository {

  OpenProductionDataRepository(this._http, this._tenantInformation);

  final AuthenticatedHttpClient _http;
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
    yield List.empty();
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

    _openDataStreamController.add(_openDataList.values.toList());
    _productionDataStreamController[productionBasicData.id] = StreamController<ProductionBasicData>.broadcast();
  }

  updateBegin(int id, DateTime? begin) {
    var prdData = _getProductionBasicData(id);
    prdData = prdData.copyWith(begin: begin);
    emitProductionChange(id, prdData);
  }

  updateEnd(int id, DateTime? end) {
    var prdData = _getProductionBasicData(id);
    prdData = prdData.copyWith(end: end);
    emitProductionChange(id, prdData);
  }

  updateComment(int id, String? comments) {
    var prdData = _getProductionBasicData(id);
    prdData = prdData.copyWith(comments: comments);
    emitProductionChange(id, prdData);
  }

  void emitProductionChange(int id, ProductionBasicData prdData) {
    _openDataList[id] = prdData;
    _openDataStreamController.add(_openDataList.values.toList());
    _productionDataStreamController[id]?.add(prdData);
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