import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'line_unit.dart';

class ProductionLoss extends Equatable {

  final int id;
  final int lineUnitId;
  final int lossCurrentDefinitionId;
  final String? code;
  final String name;
  final String? unit;
  final double? lossValue;
  final int order;

  ProductionLoss({ 
    required this.id, 
    required this.lineUnitId, 
    required this.lossCurrentDefinitionId, 
    required this.code, 
    required this.name, 
    required this.unit, 
    required this.lossValue, 
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
      lossValue: json['lossValue'], 
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
      lossValue,
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
    double? lossValue,
    int? order,
  }) {
    return ProductionLoss(
      id: id ?? this.id,
      lineUnitId: lineUnitId ?? this.lineUnitId,
      lossCurrentDefinitionId: lossCurrentDefinitionId ?? this.lossCurrentDefinitionId,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      lossValue: lossValue ?? this.lossValue,
      order: order ?? this.order,
    );
  }
}

extension ProductionLossExtensions on ProductionLoss {

  String getFormatedLossValue() {
    var f = NumberFormat("##0.0#", "en_US");
    if (lossValue == null) {
      return "";
    } else if (unit == null) {
      return f.format(lossValue);
    } else {
      return f.format(lossValue) + ' ' + unit!;
    }
  }
}