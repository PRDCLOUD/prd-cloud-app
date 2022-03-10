import 'line_unit.dart';

class ProductionLoss {

  final int id;
  final int productionBasicDataId;
  final int lineUnitId;
  final LineUnit lineUnit;
  final int lossCurrentDefinitionId;
  final String code;
  final String name;
  final String unit;
  final double numberValue;
  final int order;

  ProductionLoss({ 
    required this.id, 
    required this.productionBasicDataId, 
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
      productionBasicDataId: json['productionBasicDataId'], 
      lineUnitId: json['lineUnitId'], 
      lineUnit: LineUnit.fromJson(json['lineUnit']), 
      lossCurrentDefinitionId: json['lossCurrentDefinitionId'], 
      code: json['code'], 
      name: json['name'], 
      unit: json['unit'], 
      numberValue: json['numberValue'], 
      order: json['order']);
  }

}