import 'dart:async';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:timezone/timezone.dart' as tz;

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

  Future<Response> _postRequest(String path, [ dynamic data = null ]) async {

    var accessToken = await _getAccessToken();

    var response = await _dio.postUri(Uri.https(_authority, _tenant.name + '/' + path), data: data, options: Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        'Authorization': 'Bearer ' + accessToken
      })
    );

    return response;  
  }

  Future<Response> _deleteRequest(String path, [ dynamic data = null ]) async {

    var accessToken = await _getAccessToken();

    var response = await _dio.deleteUri(Uri.https(_authority, _tenant.name + '/' + path), data: data, options: Options(
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
    return (await _getRequest('api/production/open', 
    { 
      'type': 'all', 
      'take': take.toString() 
    }));
  }

  Future<Response> getProductionDataById(int id) async {
    return await _getRequest('api/production/' + id.toString());
  }

  Future<Response<dynamic>> patchProductionDataBegin(ProductionBasicData productionBasicData, String timeZone) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, timeZone),
      'end': dateToString(productionBasicData.end, timeZone),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/begin/' + productionBasicData.id.toString(), data);
  }

  Future<Response<dynamic>> patchProductionDataEnd(ProductionBasicData productionBasicData, String timeZone) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, timeZone),
      'end': dateToString(productionBasicData.end, timeZone),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/end/' + productionBasicData.id.toString(), data);
  }

  Future<Response<dynamic>> patchProductionDataComments(ProductionBasicData productionBasicData, String timeZone) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, timeZone),
      'end': dateToString(productionBasicData.end, timeZone),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/comment/' + productionBasicData.id.toString(), data);
  }

  Future<Response<dynamic>> patchProductionDataProduct(ProductionBasicData productionBasicData, String timeZone) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, timeZone),
      'end': dateToString(productionBasicData.end, timeZone),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/product/' + productionBasicData.id.toString(), data);
  }

  Future<Response<dynamic>> patchProductionVariable(ProductionVariable variable) async {
    var data = { 
      'definitionName': variable.definitionName,
      'productionBasicDataId': variable.productionBasicDataId,
      'text': variable.text,
      'id': variable.id,
      'value': variable.value,
      'type': variable.typeVariableDefinition.toLowerCase()
    };
    return await _patchRequest('api/production/variable/' + variable.typeVariableDefinition.toLowerCase() + '/' + variable.id.toString(), data);
  }

  Future<Response<dynamic>> postProductionLoss(int productionBasicDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId) async {
    var data = { 
      'lineUnitIds': [ lineUnitId ],
      'productionLoss': {
        'lineUnitId': lineUnitId,
        'lossCurrentDefinitionId': lossCurrentDefinitionId,
        'lossValue': lossValue,
        'productionBasicDataId': productionBasicDataId
      },
    };
    return await _postRequest('api/production/loss', data);
  }

  Future<Response<dynamic>> deleteProductionLoss(int productionLossId) async {
    return await _deleteRequest('api/production/loss/' + productionLossId.toString());
  }

  String? dateToString(DateTime? date, String locationName) {
    if (date == null) {
      return null;
    } else {
      var timezone = tz.getLocation(locationName);
      var dateOnLocal = tz.TZDateTime(timezone, date.year, date.month, date.day, date.hour, date.minute, date.second);
      return dateOnLocal.toIso8601String();
    }
  }

}