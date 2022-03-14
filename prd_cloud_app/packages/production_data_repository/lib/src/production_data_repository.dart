import 'dart:async';

import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';


class ProductionDataRepository {

  final AuthenticatedHttpClient _http;
  final TenantInformation _tenantInformation;

  ProductionDataRepository(this._http, this._tenantInformation);

  Future<List<dynamic>> getApontamentos(ProductionDataFilter filter) async {
    return await _http.getProductionDataList(filter.status, filter.take, filter.prdLines);
  }

  Future<ProductionBasicData> getApontamento(int id) async {
    var response = await _http.getProductionDataById(id);
    return ProductionBasicData.fromJson(response.data[0], _tenantInformation.location);
  }
}