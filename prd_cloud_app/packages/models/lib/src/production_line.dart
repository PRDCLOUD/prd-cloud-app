import 'package:equatable/equatable.dart';

class ProductionLine extends Equatable {

  final int id;
  final String name;
  final String type;

  ProductionLine({ required this.id, 
         required this.name, 
         required this.type});


  factory ProductionLine.fromJson(Map<String, dynamic> json) {
    
    return ProductionLine(
      id: json['id'],
      name: json['name'],
      type: json['type']
    );
  }


  @override
  List<Object> get props => [id, name, type];

  ProductionLine copyWith({
    int? id,
    String? name,
    String? type,
  }) {
    return ProductionLine(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
