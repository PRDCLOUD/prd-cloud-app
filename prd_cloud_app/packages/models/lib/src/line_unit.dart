class LineUnit {

  final String code;
  final String description;
  final int id;
  final String name;
  final int order;
  final int productionLineId;
  final String publicDiscriminator;

  LineUnit({ required this.code, required this.description, required this.id, required this.name, required this.order, required this.productionLineId, required this.publicDiscriminator });

  factory LineUnit.fromJson(Map<String, dynamic> json) {
    return LineUnit(
      code: json['code'],
      description: json['description'],
      id: json['id'],
      name: json['name'],
      order: json['order'],
      productionLineId: json['productionLineId'],
      publicDiscriminator: json['publicDiscriminator']
    );
  }
  
}