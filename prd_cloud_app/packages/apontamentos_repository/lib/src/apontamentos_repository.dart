import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:models/models.dart';


class ApontamentosRepository {

  final ApiConnectionData _apiConnectionData;

  ApontamentosRepository(this._apiConnectionData);

  Future<List<dynamic>> getApontamentos(String tenant, ) async {
    Map<String, dynamic> queryParams = Map();
    queryParams['type'] = "All";
    queryParams['take'] = 100;

    var response = await http.get(Uri.https(_apiConnectionData.authority, '/api/production/concluded', queryParams));

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list;
    } else {
      return new List.empty();
    }
  }
}