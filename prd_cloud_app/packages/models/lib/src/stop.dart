class Stop {
  final int id;
  final String? code;
  final String name;
  final int typeOf;
  final double averageTime;
  final bool active;
  final List<LineUnitStop> lineUnitStops;
  final List<StopClaim> stopClaims;

  Stop({
    required this.id, 
    required this.code, 
    required this.name, 
    required this.typeOf, 
    required this.averageTime, 
    required this.active, 
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
        active: json['active'],
        averageTime: json['averageTime'],
        code: json['code'],
        name: json['name'],
        typeOf: json['typeOf'],
        stopClaims: json['stopClaims']?.map((x) => StopClaim.fromJson(x)).toList(),
        lineUnitStops: json['lineUnitStops']?.map((x) => LineUnitStop.fromJson(x)).toList(),
      );
    }

}

class LineUnitStop {

  final int lineUnitId;
  final int stopDefinitionId;

  LineUnitStop({required this.lineUnitId, required this.stopDefinitionId});

  factory LineUnitStop.fromJson(Map<String, dynamic> json) {
    return LineUnitStop(
      lineUnitId: json['lineUnitId'] as int, 
      stopDefinitionId: json['stopDefinitionId'] as int
    );
  }
}

class StopClaim {

  final String claim;
  final String claimValue;
  final String? defaultValue;
  final List<String>? valueList;
  final bool onTheFly;
  final bool required;

  StopClaim({required this.claim, required this.claimValue, required this.defaultValue, required this.valueList, required this.onTheFly, required this.required});

  String showValue() {
    if (this.onTheFly && this.valueList != null) {
      return this.valueList!.join(', ');
    } else {
      return this.claimValue;
    }
  }

  factory StopClaim.fromJson(Map<String, dynamic> json) {
    return StopClaim(
      claim: json['claim'] as String,
      claimValue: json['claimValue'] as String,
      defaultValue: json['defaultValue'] as String?,
      onTheFly: json['onTheFly'] as bool,
      required: json['required'] as bool,
      valueList: json['valueList']?.map((x) => x.toString()).toList()
    );
  }

}
