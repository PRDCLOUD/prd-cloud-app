import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:timezone/timezone.dart' as tz;


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

  factory LineUnit.fromJson(Map<String, dynamic> json, tz.Location location) {

    var productionVariables = (json['productionVariables']?.map((x) => ProductionVariable.fromJson(x, location)).cast<ProductionVariable>().toList() ?? List<ProductionVariable>.empty()) as List<ProductionVariable>;
    productionVariables = productionVariables.where((e) => e.width != 0).toList();
    productionVariables.sort((a, b) => (a.rowOrder - b.rowOrder) != 0 ? (a.rowOrder - b.rowOrder) : (a.columnOrder - b.columnOrder));

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
      productionVariables
    ];
  }
  

  LineUnit copyWithNewVariables({List<ProductionVariable>? productionVariables}) {
    return LineUnit(
      code: code,
      description: description,
      id: id,
      name: name,
      order: order,
      productionLineId: productionLineId,
      publicDiscriminator: publicDiscriminator,
      products: products,
      productionVariables: productionVariables ?? this.productionVariables
    );
  }
}
