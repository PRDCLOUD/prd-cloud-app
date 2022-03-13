import 'package:equatable/equatable.dart';

import 'line_unit.dart';

class ProductionLoss extends Equatable {

  final int id;
  final int lineUnitId;
  final int lossCurrentDefinitionId;
  final String? code;
  final String name;
  final String? unit;
  final double? numberValue;
  final int order;

  ProductionLoss({ 
    required this.id, 
    required this.lineUnitId, 
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
      lossCurrentDefinitionId,
      code,
      name,
      unit,
      numberValue,
      order,
    ];
  }

  ProductionLoss copyWith({
    int? id,
    int? lineUnitId,
    LineUnit? lineUnit,
    int? lossCurrentDefinitionId,
    String? code,
    String? name,
    String? unit,
    double? numberValue,
    int? order,
  }) {
    return ProductionLoss(
      id: id ?? this.id,
      lineUnitId: lineUnitId ?? this.lineUnitId,
      lossCurrentDefinitionId: lossCurrentDefinitionId ?? this.lossCurrentDefinitionId,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      numberValue: numberValue ?? this.numberValue,
      order: order ?? this.order,
    );
  }
}
