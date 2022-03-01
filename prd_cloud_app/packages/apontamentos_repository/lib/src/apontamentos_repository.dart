import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';


class ApontamentosRepository {

  final AuthenticatedHttpClient _http;

  ApontamentosRepository(this._http);

  Future<List<dynamic>> getApontamentos(int take) async {

    var response = await _http.getProductionData(take);

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list;
    } else {
      return new List.empty();
    }
  }
}