import 'dart:async';
import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';

class ProductionLineRepository {

  final AuthenticatedHttpClient _authenticatedHttpClient;

  ProductionLineRepository(AuthenticatedHttpClient authenticatedHttpClient) : _authenticatedHttpClient = authenticatedHttpClient;

  Future<List<ProductionLineAndGroup>> getProductionLineAndGroupsList() async {
    return await _authenticatedHttpClient.getProductionLineAndGroupsList();
  }

}