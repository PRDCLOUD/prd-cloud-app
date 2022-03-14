import 'package:equatable/equatable.dart';

class ProductionLineAndGroup extends Equatable {

  final String id;
  final String name;
  final String type;

  ProductionLineAndGroup({ required this.id, 
         required this.name, 
         required this.type});


  factory ProductionLineAndGroup.fromJson(Map<String, dynamic> json) {
    
    return ProductionLineAndGroup(
      id: json['id'],
      name: json['text'],
      type: json['type']
    );
  }


  @override
  List<Object> get props => [id, name, type];

  ProductionLineAndGroup copyWith({
    String? id,
    String? name,
    String? type,
  }) {
    return ProductionLineAndGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
