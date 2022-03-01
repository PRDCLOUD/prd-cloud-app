import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:models/src/stop.dart';

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

  // lossesOptions: Loss[];
  final List<Stop> stops;

  final String comments;

  final int status;

  ProductionBasicData({required this.id, required this.begin, required this.end, required this.productId, required this.productionLineId, required this.stops, required this.comments, required this.status});


  factory ProductionBasicData.fromJson(Map<String, dynamic> json) {

    return ProductionBasicData(
      begin: json['begin'],
      end: json['end'],
      comments: json['comments'],
      productId: json['productId'],
      id: json['id'],
      productionLineId: json['productionLineId'],
      status: json['status'],
      stops: json['stop'].map((x) => Stop.fromJson(x)).toList()
    );
  }
}