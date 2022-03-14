import 'package:equatable/equatable.dart';

class Loss extends Equatable {

  final int id;
  final String? code;
  final String name;
  final String unit;
  final int order;
  final String lossGridOption;

  final List<int> lineUnitLoss;

  Loss({ required this.id, 
         required this.code, 
         required this.name, 
         required this.unit, 
         required this.order, 
         required this.lossGridOption, 
         required this.lineUnitLoss });


  factory Loss.fromJson(Map<String, dynamic> json) {
    
    return Loss(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      unit: json['unit'],
      order: json['order'],
      lossGridOption: json['lossGridOption'],
      lineUnitLoss: json['lineUnitLoss']?.map((x) => x['lineUnitId']).cast<int>().toList(),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      code,
      name,
      unit,
      order,
      lossGridOption,
      lineUnitLoss,
    ];
  }

  Loss copyWith({
    int? id,
    String? code,
    String? name,
    String? unit,
    int? order,
    String? lossGridOption,
    List<int>? lineUnitLoss,
  }) {
    return Loss(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      order: order ?? this.order,
      lossGridOption: lossGridOption ?? this.lossGridOption,
      lineUnitLoss: lineUnitLoss ?? this.lineUnitLoss,
    );
  }
}
