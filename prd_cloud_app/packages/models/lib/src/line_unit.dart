import 'package:equatable/equatable.dart';

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

  LineUnit({ 
    required this.code, 
    required this.description, 
    required this.id, 
    required this.name, 
    required this.order, 
    required this.productionLineId, 
    required this.publicDiscriminator,
    required this.products
    });

  factory LineUnit.fromJson(Map<String, dynamic> json) {
    return LineUnit(
      code: json['code'],
      description: json['description'],
      id: json['id'],
      name: json['name'],
      order: json['order'],
      productionLineId: json['productionLineId'],
      publicDiscriminator: json['publicDiscriminator'],
      products: json['productionLineProducts']?.map((x) => Product.fromJson(x['product'])).cast<Product>().toList()
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
  
}
