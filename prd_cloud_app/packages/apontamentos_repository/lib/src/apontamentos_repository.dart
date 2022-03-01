import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:models/models.dart';


class ApontamentosRepository {

  final ApiConnectionData _apiConnectionData;

  ApontamentosRepository(this._apiConnectionData);

  Future<List<dynamic>> getApontamentos(int take) async {
    var accessToken = await _apiConnectionData.getAccessToken();

    Map<String, dynamic> queryParams = Map();
    queryParams['type'] = "All";
    queryParams['take'] = take;

    var response = await http.get(Uri.https(_apiConnectionData.authority, _apiConnectionData.tenant + '/api/production/concluded', queryParams), headers: {
      'Authorization' : 'Basic ' + accessToken,
      'Content-Type' : 'application/json'
    });

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list;
    } else {
      return new List.empty();
    }
  }
}