import 'dart:async';

import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';


class ProductionDataRepository {

  final AuthenticatedHttpClient _http;
  final TenantInformation _tenantInformation;

  ProductionDataRepository(this._http, this._tenantInformation);

  Future<List<ProductionItemOfList>> getApontamentos(ProductionDataFilter filter) async {
    var result = await _http.getProductionDataList(filter.status, filter.take, filter.prdLines);
    return result.map((json) => ProductionItemOfList.fromJson(filter.status, json, _tenantInformation.location)).toList();
  }

  Future<ProductionBasicData> getApontamento(int id) async {
    var response = await _http.getProductionDataById(id);
    return ProductionBasicData.fromJson(response.data[0], _tenantInformation.location);
  }

  Future<void> cancelApontamento(int id) async {
    await _http.patchCancelProductionDataById(id);
  }

  Future<void> reopenApontamento(int id) async {
    await _http.patchReopenProductionDataById(id);
  }

}