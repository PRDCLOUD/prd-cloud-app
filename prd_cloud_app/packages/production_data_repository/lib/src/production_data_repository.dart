import 'dart:async';

import 'package:dio/dio.dart';
import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';


class ProductionDataRepository {

  final AuthenticatedHttpClient _http;
  final TenantInformation _tenantInformation;

  ProductionDataRepository(this._http, this._tenantInformation);

  Future<Response> getApontamentos(int take) async {
    var response = await _http.getProductionDataList(take);
    return response;
  }

  Future<ProductionBasicData> getApontamento(int id) async {
    var response = await _http.getProductionDataById(id);
    return ProductionBasicData.fromJson(response.data[0], _tenantInformation.timeZone);
  }
}