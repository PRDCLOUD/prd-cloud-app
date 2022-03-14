import 'package:equatable/equatable.dart';

class ProductionLineAndGroups extends Equatable {

  final String id;
  final String name;
  final String type;

  ProductionLineAndGroups({ required this.id, 
         required this.name, 
         required this.type});


  factory ProductionLineAndGroups.fromJson(Map<String, dynamic> json) {
    
    return ProductionLineAndGroups(
      id: json['id'],
      name: json['name'],
      type: json['type']
    );
  }


  @override
  List<Object> get props => [id, name, type];

  ProductionLineAndGroups copyWith({
    String? id,
    String? name,
    String? type,
  }) {
    return ProductionLineAndGroups(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
