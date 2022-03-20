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

  Product copyWith({
    int? id,
    String? code,
    String? productFamily,
    String? name,
  }) {
    return Product(
      id: id ?? this.id,
      code: code ?? this.code,
      productFamily: productFamily ?? this.productFamily,
      name: name ?? this.name,
    );
  }

  String getNameCode() => code != null ? (name + " (" + code! + ")") : name;
}
