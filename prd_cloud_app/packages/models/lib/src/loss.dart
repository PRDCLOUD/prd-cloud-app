class Loss {

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
}
