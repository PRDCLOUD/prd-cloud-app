import 'package:models/src/stop.dart';

import 'loss.dart';

enum ProductionDataStatus { concluded, opened, canceled }

class ProductionBasicData {

  final int id;

  final DateTime begin;
  final DateTime end;

  final int? productId;
  // product: Product;

  final int? productionLineId;
  // productionLine: LineUnit;

  // variables: ProductionVariable[];
  // lineUnits: ProductionLineUnit[];
  // losses: ProductionLoss[];
  // stops: ProductionStop[];

  final List<Loss> lossesOptions;
  final List<Stop> stopOptions;

  final String comments;

  final int status;

  ProductionBasicData({required this.id, required this.begin, required this.end, required this.productId, required this.productionLineId, required this.comments, required this.status, required this.stopOptions, required this.lossesOptions });


  factory ProductionBasicData.fromJson(Map<String, dynamic> json, String timezone) {

    return ProductionBasicData(
      begin: DateTime.parse(json['begin']),
      end: DateTime.parse(json['end']),
      comments: json['comments'],
      productId: json['productId'],
      id: json['id'],
      productionLineId: json['productionLineId'],
      status: json['status'],
      stopOptions: json['stopOptions'].map((x) => Stop.fromJson(x)).toList(),
      lossesOptions: json['lossesOptions'].map((x) => Loss.fromJson(x)).toList(),
    );
  }
}