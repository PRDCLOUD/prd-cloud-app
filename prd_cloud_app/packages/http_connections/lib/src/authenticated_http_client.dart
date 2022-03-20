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

  Future<Response> _getRequest(String path, { Map<String, dynamic>? queryParams = null }) async {

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

  Future<Response> _patchRequest(String path, { dynamic data = null }) async {

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

  Future<Response> _postRequest(String path, { dynamic data = null, Map<String, dynamic>? queryParams = null }) async {

    var accessToken = await _getAccessToken();

    var response = await _dio.postUri(Uri.https(_authority, _tenant.name + '/' + path, queryParams), data: data, options: Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        'Authorization': 'Bearer ' + accessToken
      })
    );

    return response;  
  }

  Future<Response> _deleteRequest(String path, { dynamic data = null }) async {

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

  Future<List<ProductionLineAndGroup>> getProductionLineAndGroupsList() async {
    var response = await _getRequest('api/lineunit/prdlineandgroups');
    var productionLines = response.data?.map((x) => ProductionLineAndGroup.fromJson(x)).cast<ProductionLineAndGroup>().toList();
    return productionLines; 
  }

  Future<List<dynamic>> getProductionDataList(ProductionDataStatus status, int take, List<String> prdLines) async {

    var statusString = () {
      switch (status) {
        case ProductionDataStatus.canceled: return 'cancel';
        case ProductionDataStatus.concluded: return 'concluded';
        case ProductionDataStatus.opened: return 'open';
        default: throw new Exception('Invalid Status');
      }
    };

    var response = await _getRequest('api/production/list', queryParams: 
    { 
      'status': statusString(),
      'take': take.toString(),
      'prdLine': prdLines
    });

    if (response.statusCode == 204 || response.data == null || response.data == "") {
      return List.empty();
    } else {
      return response.data;
    }
  }

  Future<Response> getProductionDataById(int id) async {
    return await _getRequest('api/production/' + id.toString());
  }

  Future<int> postOpenInputProductionData(String lineId, bool isGroup) async {
    if (isGroup) {
      var response = await _postRequest('api/production/open/group', queryParams:  { 'group': lineId});
      return response.data['id'] as int; 
    } else {
      var response = await _postRequest('api/production/open/' + lineId);
      return response.data['id'] as int; 
    }
  }

  Future<Response> patchCancelProductionDataById(int id) async {
    return await _patchRequest('api/production/cancel/' + id.toString());
  }

  Future<Response> patchReopenProductionDataById(int id) async {
    return await _patchRequest('api/production/open/' + id.toString());
  }

  Future<Response<dynamic>> patchProductionDataBegin(ProductionData productionBasicData, tz.Location location) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, location),
      'end': dateToString(productionBasicData.end, location),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/begin/' + productionBasicData.id.toString(), data: data);
  }

  Future<Response<dynamic>> patchProductionDataEnd(ProductionData productionBasicData, tz.Location location) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, location),
      'end': dateToString(productionBasicData.end, location),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/end/' + productionBasicData.id.toString(), data: data);
  }

  Future<Response<dynamic>> patchProductionDataComments(ProductionData productionBasicData, tz.Location location) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, location),
      'end': dateToString(productionBasicData.end, location),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/comment/' + productionBasicData.id.toString(), data: data);
  }

  Future<Response<dynamic>> patchProductionDataProduct(ProductionData productionBasicData, tz.Location locale) async {
    var data = { 
      'begin': dateToString(productionBasicData.begin, locale),
      'end': dateToString(productionBasicData.end, locale),
      'comments': productionBasicData.comments,
      'id': productionBasicData.id,
      'productId': productionBasicData.productId
    };
    return await _patchRequest('api/production/product/' + productionBasicData.id.toString(), data: data);
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
    return await _patchRequest('api/production/variable/' + variable.typeVariableDefinition.toLowerCase() + '/' + variable.id.toString(), data: data);
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
    return await _postRequest('api/production/loss', data: data);
  }

  Future<Response<dynamic>> deleteProductionLoss(int productionLossId) async {
    return await _deleteRequest('api/production/loss/' + productionLossId.toString());
  }

  Future<Response<dynamic>> postProductionStop({
    required int productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId,
    required StopTypeOf stopType,
    required List<StopClaim> claims, 
    required tz.Location location,
    double? averageTimeAtStopQtyAverageTime, 
    int? qtyAtStopQtyAverageTime,
    DateTime? beginAtStopBeginAndTimeSpan,
    double? timeSpanAtStopBeginAndTimeSpan,
    DateTime? beginAtStopBeginEnd,
    DateTime? endAtStopBeginEnd,
    int? qtyAtStopQtyTotalTime,
    double? totalTimeAtStopQtyTotalTime,
    double? stopTimeAtStopTimePerStop
  }) async {
      var data = { 
      'lineUnitIds': [ lineUnitId ],
      'productionBasicDataIds': [ productionBasicDataId ],
      'productionStop': {
        'stopCurrentDefinitionId': stopCurrentDefinitionId,

        'averageTimeAtStopQtyAverageTime': averageTimeAtStopQtyAverageTime, // StopQtyAverageTime
        'qtyAtStopQtyAverageTime': qtyAtStopQtyAverageTime, // StopQtyAverageTime

        'beginAtStopBeginAndTimeSpan': dateToString(beginAtStopBeginAndTimeSpan, location), // StopBeginAndTimeSpan
        'timeSpanAtStopBeginAndTimeSpan': timeSpanAtStopBeginAndTimeSpan, // StopBeginAndTimeSpan
        
        'beginAtStopBeginEnd': dateToString(beginAtStopBeginEnd, location), // StopBeginEnd
        'endAtStopBeginEnd': dateToString(endAtStopBeginEnd, location), // StopBeginEnd

        'qtyAtStopQtyTotalTime': qtyAtStopQtyTotalTime, // StopQtyTotalTime
        'totalTimeAtStopQtyTotalTime': totalTimeAtStopQtyTotalTime, // StopQtyTotalTie

        'stopTimeAtStopTimePerStop': stopTimeAtStopTimePerStop, // StopTimePerStop

        'claims': Map<String, dynamic>.fromIterable(claims, key: (x) => x.claim.toString(), value: (x) => x.toJson())
      },
    };
    
    return await _postRequest(_endpointAddStop(stopType), data: data);
  }

  String _endpointAddStop(StopTypeOf typeOf) {
    switch (typeOf) {
      case StopTypeOf.QtyTotalTime: return 'api/production/stop/StopQtyTotalTime';
      case StopTypeOf.BeginEnd: return 'api/production/stop/StopBeginEnd';
      case StopTypeOf.QtyAverageTime: return 'api/production/stop/StopQtyAverageTime';
      case StopTypeOf.TimeBegin: return 'api/production/stop/StopBeginTimeSpan';
      case StopTypeOf.TimePerStop: return 'api/production/stop/StopTimePerStop';
    }
  }

  Future<Response<dynamic>> deleteProductionStop(int productionStopId) async {
    return await _deleteRequest('api/production/stop/' + productionStopId.toString());
  }

  Future<void> patchConcludeProduction(ProductionDataGroup productionDataGroup, tz.Location location) async {

    var dataRows = productionDataGroup.productionDataGroup.map((e) {

      var variables = e.lineUnits.expand((x) => x.lineUnit.productionVariables).toList().map((e) => {
        'id': e.id,
        'productionBasicDataId': e.productionBasicDataId,
        'text': e.text,
        'type': e.typeVariableDefinition,
        'value': e.value,
        'definitionName': e.definitionName
      }).toList();

      return Map<String, dynamic>.from( {
        'id': e.id,
        'begin': dateToString(e.begin, location),
        'end': dateToString(e.end, location),
        'comments': e.comments,
        'productId': e.productId,
        'variables': variables.toList()
      });
      
    }).toList();

    await _patchRequest('api/production/conclude', data: { 'list': dataRows});
  }

  String? dateToString(DateTime? date, tz.Location location) {
    if (date == null) {
      return null;
    } else {
      var dateOnLocal = tz.TZDateTime(location, date.year, date.month, date.day, date.hour, date.minute, date.second);
      return dateOnLocal.toIso8601String();
    }
  }

}