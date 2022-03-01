import 'dart:async';
import 'package:dio/dio.dart';
import 'package:models/models.dart';


class AuthenticatedHttpClient {
  
  final Dio _dio = Dio();
  final Tenant _tenant;
  final String _authority;
  final Future<String> Function() _getAccessToken;

  AuthenticatedHttpClient(this._authority, this._tenant, this._getAccessToken);

  Future<Response> _getRequest(String path, Map<String, String> queryParams) async {

    var accessToken = await _getAccessToken();

    var response = await _dio.getUri(Uri.https(_authority, _tenant.name + '/' + path, queryParams), options: Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        'Authorization': 'Bearer ' + accessToken
      })
    );

    return response;  
  }

  Future<dynamic> getProductionData(int take) async {
    return (await _getRequest('api/production/concluded', 
    { 
      'type': 'all', 
      'take': take.toString() 
    })).data;
  }
  

}