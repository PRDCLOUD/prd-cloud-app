import 'package:models/src/line_unit.dart';

abstract class ProductionStop {
  final int id;
  final int productionBasicDataId;
  final int lineUnitId;
  final LineUnit lineUnit;
  final int stopCurrentDefinitionId;
  final String code;
  final String name;
  final String typeProductionStop;

  final List<ProductionStopClaim> claims;

  ProductionStop({ 
    required this.id, 
    required this.productionBasicDataId, 
    required this.lineUnitId, 
    required this.lineUnit, 
    required this.stopCurrentDefinitionId, 
    required this.code, 
    required this.name, 
    required this.typeProductionStop, 
    required this.claims
  });

  factory ProductionStop.fromJson(Map<String, dynamic> json) {
    switch (json['typeProductionStop']) {
      case 1: 
        return ProductionStopBeginEnd(
          id: json['id'],
          code: json['code'],
          lineUnit: LineUnit.fromJson(json['lineUnit']),
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          begin: DateTime.parse(json['begin']).toLocal(),
          end: DateTime.parse(json['end']).toLocal()
        );
      case 2: 
        return ProductionStopBeginAndTimeSpan(
          id: json['id'],
          code: json['code'],
          lineUnit: LineUnit.fromJson(json['lineUnit']),
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          begin: DateTime.parse(json['begin']).toLocal(),
          timeSpan: json['timeSpan']
        );
      case 3:
        return ProductionStopQtyAverageTime(
          id: json['id'],
          code: json['code'],
          lineUnit: LineUnit.fromJson(json['lineUnit']),
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          averageTime: json['averageTime'],
          qty: json['qty']
        );
      case 4:
        return ProductionStopQtyTotalTime(
          id: json['id'],
          code: json['code'],
          lineUnit: LineUnit.fromJson(json['lineUnit']),
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          totalTime: json['totalTime'],
          qty: json['qty']
        );
      case 5:
        return ProductionStopTimePerStop(
          id: json['id'],
          code: json['code'],
          lineUnit: LineUnit.fromJson(json['lineUnit']),
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          totalTime: json['totalTime'],
          stopTimePerStop: json['stopTimePerStop']
        );
      default:
        throw new Exception("Argument out of Range");
    }

  }

}

class ProductionStopBeginEnd extends ProductionStop {
  // StopBeginEnd
  final DateTime? begin;  // date
  final DateTime? end;

  ProductionStopBeginEnd({ 
    required id, 
    required productionBasicDataId, 
    required lineUnitId, 
    required lineUnit, 
    required stopCurrentDefinitionId, 
    required code, 
    required name, 
    required typeProductionStop, 
    required claims,
    required this.begin,
    required this.end
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnit: lineUnit, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop
  ); 

}

class ProductionStopBeginAndTimeSpan extends ProductionStop{
  final DateTime? begin;  // date
  final double? timeSpan;  // minutes

  ProductionStopBeginAndTimeSpan({ 
    required id, 
    required productionBasicDataId, 
    required lineUnitId, 
    required lineUnit, 
    required stopCurrentDefinitionId, 
    required code, 
    required name, 
    required typeProductionStop, 
    required claims,
    required this.begin,
    required this.timeSpan
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnit: lineUnit, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop
  ); 

}

class ProductionStopQtyAverageTime extends ProductionStop{
  final int? qty;  // integer
  final double? averageTime;  // minutes

  ProductionStopQtyAverageTime({ 
    required id, 
    required productionBasicDataId, 
    required lineUnitId, 
    required lineUnit, 
    required stopCurrentDefinitionId, 
    required code, 
    required name, 
    required typeProductionStop, 
    required claims,
    required this.qty,
    required this.averageTime
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnit: lineUnit, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop
  ); 

}

class ProductionStopQtyTotalTime extends ProductionStop{
  final int? qty;  // integer
  final double? totalTime;  // minutes

  ProductionStopQtyTotalTime({ 
    required id, 
    required productionBasicDataId, 
    required lineUnitId, 
    required lineUnit, 
    required stopCurrentDefinitionId, 
    required code, 
    required name, 
    required typeProductionStop, 
    required claims,
    required this.qty,
    required this.totalTime
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnit: lineUnit, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop
  ); 

}

class ProductionStopTimePerStop extends ProductionStop{
  final double? stopTimePerStop; // minutes
  final double? totalTime; // Calculated on the Server

  ProductionStopTimePerStop({ 
    required id, 
    required productionBasicDataId, 
    required lineUnitId, 
    required lineUnit, 
    required stopCurrentDefinitionId, 
    required code, 
    required name, 
    required typeProductionStop, 
    required claims,
    required this.stopTimePerStop,
    required this.totalTime
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnit: lineUnit, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop
  ); 

}

class ProductionStopClaim {

  final String claim;
  final String claimValue;
  final String? defaultValue;
  final bool onTheFly;
  final List<String>? valueList;
  final bool required;

  ProductionStopClaim({ 
    required this.claim, 
    required this.claimValue, 
    required this.defaultValue, 
    required this.onTheFly, 
    required this.valueList, 
    required this.required
  });

  factory ProductionStopClaim.fromJson(Map<String, dynamic> json) {
    return ProductionStopClaim(
      claim: json['claim'],
      claimValue: json['claimValue'],
      defaultValue: json['defaultValue'],
      onTheFly: json['onTheFly'],
      required: json['required'],
      valueList: json['valueList']?.cast<String>().toList(),
    );
  }
}