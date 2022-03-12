import 'package:equatable/equatable.dart';
import 'package:models/src/line_unit.dart';

class ProductionLineUnit extends Equatable {

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

  @override
  List<Object> get props {
    return [
      id,
      name,
      lineUnitId,
      lineUnit,
      order,
      type,
    ];
  }

  ProductionLineUnit copyWith({
    int? id,
    String? name,
    int? lineUnitId,
    LineUnit? lineUnit,
    int? order,
    String? type,
  }) {
    return ProductionLineUnit(
      id: id ?? this.id,
      name: name ?? this.name,
      lineUnitId: lineUnitId ?? this.lineUnitId,
      lineUnit: lineUnit ?? this.lineUnit,
      order: order ?? this.order,
      type: type ?? this.type,
    );
  }
}