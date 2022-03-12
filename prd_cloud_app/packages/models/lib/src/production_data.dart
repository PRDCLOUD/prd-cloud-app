import 'package:equatable/equatable.dart';
import 'package:models/src/production_line_unit.dart';
import 'package:models/src/production_loss.dart';
import 'package:models/src/production_stop.dart';
import 'package:models/src/stop.dart';

import 'loss.dart';

enum ProductionDataStatus { concluded, opened, canceled }

class ProductionBasicData extends Equatable {

  final int id;

  final DateTime? begin;
  final DateTime? end;

  final int? productId;

  final int? productionLineId;

  final List<ProductionLineUnit> lineUnits;

  final List<ProductionLoss> losses; 
  final List<ProductionStop> stops;

  final List<Loss> lossesOptions;
  final List<Stop> stopOptions;

  final String? comments;

  final int status;

  ProductionBasicData({
    required this.id, 
    required this.begin, 
    required this.end, 
    required this.productId, 
    required this.productionLineId, 
    required this.comments, 
    required this.status, 
    required this.stopOptions, 
    required this.stops,
    required this.lossesOptions, 
    required this.losses,
    required this.lineUnits 
  });


  factory ProductionBasicData.fromJson(Map<String, dynamic> json, String timezone) {

    return ProductionBasicData(
      begin: DateTime.parse(json['begin']).toLocal(),
      end: DateTime.parse(json['end']).toLocal(),
      comments: json['comments'],
      productId: json['productId'],
      id: json['id'],
      productionLineId: json['productionLineId'],
      status: json['status'],
      stopOptions: json['stopsOptions'].map((x) => Stop.fromJson(x)).cast<Stop>().toList(),
      stops: json['stops'].map((x) => ProductionStop.fromJson(x)).cast<ProductionStop>().toList(),
      lossesOptions: json['lossesOptions'].map((x) => Loss.fromJson(x)).cast<Loss>().toList(),
      losses: json['losses'].map((x) => ProductionLoss.fromJson(x)).cast<ProductionLoss>().toList(),
      lineUnits: json['lineUnits'].map((x) => ProductionLineUnit.fromJson(x)).cast<ProductionLineUnit>().toList(),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      begin,
      end,
      productId,
      productionLineId,
      lineUnits,
      losses,
      stops,
      lossesOptions,
      stopOptions,
      comments,
      status,
    ];
  }

  ProductionBasicData copyWith({
    int? id,
    DateTime? begin,
    DateTime? end,
    int? productId,
    int? productionLineId,
    List<ProductionLineUnit>? lineUnits,
    List<ProductionLoss>? losses,
    List<ProductionStop>? stops,
    List<Loss>? lossesOptions,
    List<Stop>? stopOptions,
    String? comments,
    int? status,
  }) {
    return ProductionBasicData(
      id: id ?? this.id,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      productId: productId ?? this.productId,
      productionLineId: productionLineId ?? this.productionLineId,
      lineUnits: lineUnits ?? this.lineUnits,
      losses: losses ?? this.losses,
      stops: stops ?? this.stops,
      lossesOptions: lossesOptions ?? this.lossesOptions,
      stopOptions: stopOptions ?? this.stopOptions,
      comments: comments ?? this.comments,
      status: status ?? this.status,
    );
  }
}
