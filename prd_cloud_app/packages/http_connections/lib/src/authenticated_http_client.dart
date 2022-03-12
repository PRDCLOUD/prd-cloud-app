import 'dart:async';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

class AuthenticatedHttpClient {
  
  final Dio _dio = Dio();
  final Tenant _tenant;
  final String _authority;
  final Future<String> Function() _getAccessToken;

  AuthenticatedHttpClient(this._authority, this._tenant, this._getAccessToken);

  Future<Response> _getRequest(String path, [ Map<String, String>? queryParams = null ]) async {

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

    Future<Response> _patchRequest(String path, [ dynamic data = null ]) async {

    var accessToken = await _getAccessToken();

    var response = await _dio.patchUri(Uri.https(_authority, _tenant.name + '/' + path), data: data, options: Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        'Authorization': 'Bearer ' + accessToken
      })
    );

    return response;  
  }

  Future<Response> getTenantInformation() async {
    return await _getRequest('api/tenant/claims');
  }  

  Future<Response> getProductionDataList(int take) async {
    return (await _getRequest('api/production/concluded', 
    { 
      'type': 'all', 
      'take': take.toString() 
    }));
  }

  Future<Response> getProductionDataById(int id) async {
    return await _getRequest('api/production/' + id.toString());
  }

  Future<Response<dynamic>> patchProductionDataBegin(ProductionBasicData productionBasicData) async {
    var data = { 
      'begin': productionBasicData.begin?.toIso8601String(),
      'end': productionBasicData.end?.toIso8601String(),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/begin/' + productionBasicData.id.toString(), data);
  }

  Future<Response<dynamic>> patchProductionDataEnd(ProductionBasicData productionBasicData) async {
    var data = { 
      'begin': productionBasicData.begin?.toIso8601String(),
      'end': productionBasicData.end?.toIso8601String(),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/end/' + productionBasicData.id.toString(), data);
  }

  Future<Response<dynamic>> patchProductionDataComments(ProductionBasicData productionBasicData) async {
    var data = { 
      'begin': productionBasicData.begin?.toIso8601String(),
      'end': productionBasicData.end?.toIso8601String(),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/comment/' + productionBasicData.id.toString(), data);
  }

  Future<Response<dynamic>> patchProductionDataProduct(ProductionBasicData productionBasicData) async {
    var data = { 
      'begin': productionBasicData.begin?.toIso8601String(),
      'end': productionBasicData.end?.toIso8601String(),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/product/' + productionBasicData.id.toString(), data);
  }

}