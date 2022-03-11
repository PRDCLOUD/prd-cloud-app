import 'package:equatable/equatable.dart';

class Stop extends Equatable {
  final int id;
  final String? code;
  final String name;
  final int typeOf;
  final double? averageTime;
  final List<int> lineUnitStops;
  final List<StopClaim> stopClaims;

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
      claimValue: json['value'],
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
}

