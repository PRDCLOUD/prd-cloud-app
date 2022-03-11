import 'package:models/src/line_unit.dart';

import '../models.dart';

class ProductionLineUnit {

  final int id;
  final String name;
  final int lineUnitId;
  final LineUnit lineUnit;
  final int order;
  final String type;

  ProductionLineUnit({ 
    required this.id,
    required this.name,
    required this.lineUnitId,
    required this.lineUnit,
    required this.order,
    required this.type
  });

  factory ProductionLineUnit.fromJson(Map<String, dynamic> json) {

    return ProductionLineUnit(
      id: json['id'],
      lineUnit: LineUnit.fromJson(json['lineUnit']),
      lineUnitId: json['lineUnitId'],
      name: json['name'],
      order: json['order'],
      type: json['type']
    );

  }
}
