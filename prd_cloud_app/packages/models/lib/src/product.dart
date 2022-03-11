import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String? code;
  final String productFamily;
  final String name;

  Product({required this.id, required this.code, required this.productFamily, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'], 
      code: json['code'], 
      productFamily: json['productFamily'], 
      name: json['name']
    );
  }

  @override
  List<Object?> get props => [id, code, productFamily, name];
}
