import 'dart:async';

import 'package:dio/dio.dart';
import 'package:http_connections/http_connections.dart';


class TenantDataRepository {

  final AuthenticatedHttpClient _http;

  TenantDataRepository(this._http);

  Future<Response> getTenantInformation() async {
    var response = await _http.getTenantInformation();
    return response;
  }
}