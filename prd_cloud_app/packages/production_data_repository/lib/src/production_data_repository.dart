import 'dart:async';

import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';


class ProductionDataRepository {

  final AuthenticatedHttpClient _http;
  final TenantInformation _tenantInformation;

  ProductionDataRepository(this._http, this._tenantInformation);

  Future<List<ProductionItemOfList>> getApontamentos(ProductionDataFilter filter) async {
    var result = await _http.getProductionDataList(filter.status, filter.take, filter.prdLines);
    var list = result.map((json) => ProductionItemOfList.fromJson(filter.status, json, _tenantInformation.location)).toList();
    list.sort((b, a) => a.id.compareTo(b.id));
    return list;
  }

  Future<void> cancelApontamento(int id) async {
    await _http.patchCancelProductionDataById(id);
  }

  Future<void> reopenApontamento(int id) async {
    await _http.patchReopenProductionDataById(id);
  }

}