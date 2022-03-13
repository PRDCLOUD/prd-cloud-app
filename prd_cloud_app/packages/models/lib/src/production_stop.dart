import 'package:equatable/equatable.dart';

abstract class ProductionStop extends Equatable {
  final int id;
  final int? productionBasicDataId;
  final int lineUnitId;
  final int stopCurrentDefinitionId;
  final String? code;
  final String name;
  final String? typeProductionStop;
  final double totalTime;

  final List<ProductionStopClaim>? claims;

  String get codeName {
    if (code != null) {
      return '(' + code! + ') ' + name;
    } else {
      return name;
    }
  }

  ProductionStop({ 
    required this.id, 
    required this.productionBasicDataId, 
    required this.lineUnitId, 
    required this.stopCurrentDefinitionId, 
    required this.code, 
    required this.name, 
    required this.typeProductionStop,
    required this.totalTime,
    required this.claims
  });

  factory ProductionStop.fromJson(Map<String, dynamic> json) {
    switch (json['typeProductionStop']) {
      case 'StopBeginEnd': 
        return ProductionStopBeginEnd(
          id: json['id'],
          code: json['code'],
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          totalTime: json['totalTime'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          begin: DateTime.parse(json['beginAtStopBeginEnd']).toLocal(),
          end: DateTime.parse(json['endAtStopBeginEnd']).toLocal()
        );
      case 'StopBeginTimeSpan': 
        return ProductionStopBeginAndTimeSpan(
          id: json['id'],
          code: json['code'],
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          totalTime: json['totalTime'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          begin: DateTime.parse(json['beginAtStopBeginAndTimeSpan']).toLocal(),
          timeSpan: json['timeSpanAtStopBeginAndTimeSpan']
        );
      case 'StopQtyAverageTime':
        return ProductionStopQtyAverageTime(
          id: json['id'],
          code: json['code'],
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          totalTime: json['totalTime'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          averageTime: json['averageTimeAtStopQtyAverageTime'],
          qty: json['qtyAtStopQtyAverageTime']
        );
      case 'StopQtyTotalTime':
        return ProductionStopQtyTotalTime(
          id: json['id'],
          code: json['code'],
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          totalTime: json['totalTime'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          qty: json['qtyAtStopQtyTotalTime'],
          totalTimeAtStopQtyTotalTime: json['totalTimeAtStopQtyTotalTime']
        );
      case 'StopTimePerStop':
        return ProductionStopTimePerStop(
          id: json['id'],
          code: json['code'],
          name: json['name'],
          lineUnitId: json['lineUnitId'],
          productionBasicDataId: json['productionBasicDataId'],
          stopCurrentDefinitionId: json['stopCurrentDefinitionId'],
          typeProductionStop: json['typeProductionStop'],
          totalTime: json['totalTime'],
          claims: json['claims']?.map((x) => ProductionStopClaim.fromJson(x)).cast<ProductionStopClaim>().toList(),
          stopTimePerStop: json['stopTimeAtStopTimePerStop']
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
    required int id, 
    required int? productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId, 
    required String? code, 
    required String name, 
    required String? typeProductionStop, 
    required List<ProductionStopClaim>? claims,
    required double totalTime,
    required this.begin,
    required this.end
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnitId: lineUnitId, 
    name: name, 
    totalTime: totalTime,
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop
  );

  @override
  List<Object?> get props {
    return [
      id,
      productionBasicDataId,
      lineUnitId,
      stopCurrentDefinitionId,
      code,
      name,
      typeProductionStop,
      totalTime,
      claims,
      begin,
      end
    ];
  }

}

class ProductionStopBeginAndTimeSpan extends ProductionStop{
  final DateTime? begin;  // date
  final double? timeSpan;  // minutes

  ProductionStopBeginAndTimeSpan({ 
    required int id, 
    required int? productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId, 
    required String? code, 
    required String name, 
    required String? typeProductionStop, 
    required List<ProductionStopClaim>? claims,
    required double totalTime,
    required this.begin,
    required this.timeSpan
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    totalTime: totalTime,
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop
  ); 

  @override
  List<Object?> get props {
    return [
      id,
      productionBasicDataId,
      lineUnitId,
      stopCurrentDefinitionId,
      code,
      name,
      typeProductionStop,
      totalTime,
      claims,
      begin,
      timeSpan
    ];
  }

}

class ProductionStopQtyAverageTime extends ProductionStop{
  final int? qty;  // integer
  final double? averageTime;  // minutes

  ProductionStopQtyAverageTime({ 
    required int id, 
    required int? productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId, 
    required String? code, 
    required String name, 
    required String? typeProductionStop, 
    required List<ProductionStopClaim>? claims,
    required double totalTime,
    required this.qty,
    required this.averageTime
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop,
    totalTime: totalTime
  ); 

  @override
  List<Object?> get props {
    return [
      id,
      productionBasicDataId,
      lineUnitId,
      stopCurrentDefinitionId,
      code,
      name,
      typeProductionStop,
      totalTime,
      claims,
      qty,
      averageTime
    ];
  }

}

class ProductionStopQtyTotalTime extends ProductionStop{
  final int? qty;  // integer
  final double? totalTimeAtStopQtyTotalTime;  // minutes

  ProductionStopQtyTotalTime({ 
    required int id, 
    required int? productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId, 
    required String? code, 
    required String name, 
    required String? typeProductionStop, 
    required List<ProductionStopClaim>? claims,
    required double totalTime,
    required this.qty,
    required this.totalTimeAtStopQtyTotalTime

  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop,
    totalTime: totalTime
  ); 

  @override
  List<Object?> get props {
    return [
      id,
      productionBasicDataId,
      lineUnitId,
      stopCurrentDefinitionId,
      code,
      name,
      typeProductionStop,
      totalTime,
      claims,
      qty,
      totalTimeAtStopQtyTotalTime
    ];
  }

}

class ProductionStopTimePerStop extends ProductionStop{
  final double? stopTimePerStop; // minutes

  ProductionStopTimePerStop({ 
    required int id, 
    required int? productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId, 
    required String? code, 
    required String name, 
    required String? typeProductionStop, 
    required List<ProductionStopClaim>? claims,
    required double totalTime,
    required this.stopTimePerStop
  }) : super(
    claims: claims, 
    code: code, 
    id: id, 
    lineUnitId: lineUnitId, 
    name: name, 
    productionBasicDataId: productionBasicDataId, 
    stopCurrentDefinitionId: stopCurrentDefinitionId, 
    typeProductionStop: typeProductionStop,
    totalTime: totalTime
  ); 

  @override
  List<Object?> get props {
    return [
      id,
      productionBasicDataId,
      lineUnitId,
      stopCurrentDefinitionId,
      code,
      name,
      typeProductionStop,
      totalTime,
      claims,
      stopTimePerStop
    ];
  }

}

class ProductionStopClaim extends Equatable {

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

  @override
  List<Object?> get props {
    return [
      claim,
      claimValue,
      defaultValue,
      onTheFly,
      valueList,
      required,
    ];
  }
}
