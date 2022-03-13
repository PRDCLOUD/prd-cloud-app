import 'package:equatable/equatable.dart';
import 'package:models/src/production_variable.dart';

import '../models.dart';

class LineUnit extends Equatable {

  final String? code;
  final String? description;
  final int id;
  final String name;
  final int? order;
  final int? productionLineId;
  final String publicDiscriminator;

  final List<Product>? products;
  final List<ProductionVariable> productionVariables;

  LineUnit({ 
    required this.code, 
    required this.description, 
    required this.id, 
    required this.name, 
    required this.order, 
    required this.productionLineId, 
    required this.publicDiscriminator,
    required this.products,
    required this.productionVariables
    });

  factory LineUnit.fromJson(Map<String, dynamic> json) {

    var productionVariables = (json['productionVariables']?.map((x) => ProductionVariable.fromJson(x)).cast<ProductionVariable>().toList() ?? List.empty()) as List<ProductionVariable>;
        
    return LineUnit(
      code: json['code'],
      description: json['description'],
      id: json['id'],
      name: json['name'],
      order: json['order'],
      productionLineId: json['productionLineId'],
      publicDiscriminator: json['publicDiscriminator'],
      products: json['productionLineProducts']?.map((x) => Product.fromJson(x['product'])).cast<Product>().toList(),
      productionVariables: productionVariables
    );
  }

  @override
  List<Object?> get props {
    return [
      code,
      description,
      id,
      name,
      order,
      productionLineId,
      publicDiscriminator,
      products,
    ];
  }
  

  LineUnit copyWith({
    String? code,
    String? description,
    int? id,
    String? name,
    int? order,
    int? productionLineId,
    String? publicDiscriminator,
    List<Product>? products,
    List<ProductionVariable>? productionVariables
  }) {
    return LineUnit(
      code: code ?? this.code,
      description: description ?? this.description,
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      productionLineId: productionLineId ?? this.productionLineId,
      publicDiscriminator: publicDiscriminator ?? this.publicDiscriminator,
      products: products ?? this.products,
      productionVariables: productionVariables ?? this.productionVariables
    );
  }
}
