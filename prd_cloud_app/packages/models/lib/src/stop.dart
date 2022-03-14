import 'package:equatable/equatable.dart';

enum StopTypeOf {
  BeginEnd,
  TimeBegin,
  QtyAverageTime,
  QtyTotalTime,
  TimePerStop
}
class Stop extends Equatable {
  
  final int id;
  final String? code;
  final String name;
  final int typeOf;
  final double? averageTime;
  final List<int> lineUnitStops;
  final List<StopClaim> stopClaims;

  StopTypeOf get stopTypeOf {
    switch (typeOf) {
      case 1: return StopTypeOf.BeginEnd;
      case 2: return StopTypeOf.TimeBegin;
      case 3: return StopTypeOf.QtyAverageTime;
      case 4: return StopTypeOf.QtyTotalTime;
      case 5: return StopTypeOf.TimePerStop;
      default: throw new Exception('Unknown Stop Type');
    }
  }

  String get codeName {
    if (code != null) {
      return '(' + code! + ') ' + name;
    } else {
      return name;
    }
  }

  Stop({
    required this.id, 
    required this.code, 
    required this.name, 
    required this.typeOf, 
    required this.averageTime, 
    required this.lineUnitStops, 
    required this.stopClaims
    });

    String get nameWithCode {
      if (this.code != null) {
          return '(' + this.code! + ') ' + this.name;
      }
      return this.name;
    }

    factory Stop.fromJson(Map<String, dynamic> json) {
      
      return Stop(
        id: json['id'],
        averageTime: json['averageTime'],
        code: json['code'],
        name: json['name'],
        typeOf: json['typeOf'],
        stopClaims: json['claims'].keys?.map((key) => StopClaim.fromJson(key, json['claims'][key])).cast<StopClaim>().toList(),
        lineUnitStops: json['lineUnitStop']?.map((x) => x['lineUnitId']).cast<int>().toList(),
      );
    }


  @override
  List<Object?> get props {
    return [
      id,
      code,
      name,
      typeOf,
      averageTime,
      lineUnitStops,
      stopClaims,
    ];
  }

  Stop copyWith({
    int? id,
    String? code,
    String? name,
    int? typeOf,
    double? averageTime,
    List<int>? lineUnitStops,
    List<StopClaim>? stopClaims,
  }) {
    return Stop(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      typeOf: typeOf ?? this.typeOf,
      averageTime: averageTime ?? this.averageTime,
      lineUnitStops: lineUnitStops ?? this.lineUnitStops,
      stopClaims: stopClaims ?? this.stopClaims,
    );
  }
}

class StopClaim extends Equatable {

  final String claim;
  final String claimValue;
  final String defaultValue;
  final List<String> valueList;
  final bool onTheFly;
  final bool required;

  StopClaim({ required this.claim, required this.claimValue, required this.defaultValue, required this.valueList, required this.onTheFly, required this.required });

  factory StopClaim.fromJson(String claim, Map<String, dynamic> json) {
    return StopClaim(
      claim: claim,
      claimValue: json['value'] ?? json['defaultValue'],
      onTheFly: json['onTheFly'],
      valueList: json['valueList'],
      defaultValue: json['defaultValue'],
      required: json['required'],
    );
  }

  @override
  List<Object> get props {
    return [
      claim,
      claimValue,
      defaultValue,
      valueList,
      onTheFly,
      required,
    ];
  }

  dynamic toJson() {
    return {
      'onTheFly': onTheFly,
      'required': required,
      'value': claimValue,
      'valueList': valueList
    };
  }
}

