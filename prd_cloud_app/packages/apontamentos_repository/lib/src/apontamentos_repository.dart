import 'dart:async';

import 'package:http_connections/http_connections.dart';


class ApontamentosRepository {

  final AuthenticatedHttpClient _http;

  ApontamentosRepository(this._http);

  Future<List<dynamic>> getApontamentos(int take) async {
    var response = await _http.getProductionData(take);
    return response;
  }
}