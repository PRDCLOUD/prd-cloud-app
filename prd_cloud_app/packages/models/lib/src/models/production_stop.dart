import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:models/src/utils/date_time_functions.dart';
import 'package:timezone/timezone.dart' as tz;

abstract class ProductionStop extends Equatable {
  final int id;
  final int? productionBasicDataId;
  final int lineUnitId;
  final int stopCurrentDefinitionId;
  final String? code;
  final String name;
  final String? typeProductionStop;
  final double? totalTime;

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
  });

  factory ProductionStop.fromJson(Map<String, dynamic> json, tz.Location location) {
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
          begin: DateTimeFunctions.parseDateTime(json['beginAtStopBeginEnd'], location),
          end: DateTimeFunctions.parseDateTime(json['endAtStopBeginEnd'], location)
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
          begin: DateTimeFunctions.parseDateTime(json['beginAtStopBeginAndTimeSpan'], location),
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
    required double totalTime,
    required this.begin,
    required this.end
  }) : super(
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
    required double totalTime,
    required this.begin,
    required this.timeSpan
  }) : super(
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
    required double totalTime,
    required this.qty,
    required this.averageTime
  }) : super(
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
    required double totalTime,
    required this.qty,
    required this.totalTimeAtStopQtyTotalTime

  }) : super(
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
    required double totalTime,
    required this.stopTimePerStop
  }) : super(
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

extension ProductionStopExtensions on ProductionStop {

  String getFormatedStopValue() {
    var f = NumberFormat("##0.0#", "en_US");
    if (totalTime == null) {
      return "";
    } else {
      return f.format(totalTime) + " min";
    }
  }
}
