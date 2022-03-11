import 'package:equatable/equatable.dart';

import 'line_unit.dart';

class ProductionLoss extends Equatable {

  final int id;
  final int lineUnitId;
  final LineUnit lineUnit;
  final int lossCurrentDefinitionId;
  final String? code;
  final String? name;
  final String? unit;
  final double? numberValue;
  final int order;

  ProductionLoss({ 
    required this.id, 
    required this.lineUnitId, 
    required this.lineUnit, 
    required this.lossCurrentDefinitionId, 
    required this.code, 
    required this.name, 
    required this.unit, 
    required this.numberValue, 
    required this.order 
  });

  factory ProductionLoss.fromJson(Map<String, dynamic> json) {
    return ProductionLoss(
      id: json['id'], 
      lineUnitId: json['lineUnitId'], 
      lineUnit: LineUnit.fromJson(json['lineUnit']), 
      lossCurrentDefinitionId: json['lossCurrentDefinitionId'], 
      code: json['code'], 
      name: json['name'], 
      unit: json['unit'], 
      numberValue: json['numberValue'], 
      order: json['order']);
  }


  @override
  List<Object?> get props {
    return [
      id,
      lineUnitId,
      lineUnit,
      lossCurrentDefinitionId,
      code,
      name,
      unit,
      numberValue,
      order,
    ];
  }
}
