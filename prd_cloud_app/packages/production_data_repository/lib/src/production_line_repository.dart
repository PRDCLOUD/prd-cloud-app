import 'dart:async';
import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';

class ProductionLineRepository {

  final AuthenticatedHttpClient _http;

  ProductionLineRepository(this._http);

  Future<List<ProductionLineAndGroups>> getProductionLineAndGroupsList(int take) async {
    return await _http.getProductionLineAndGroupsList();
  }

}