class Loss {

  final int id;
  final String code;
  final String name;
  final String description;
  final String unit;
  final int order;
  final String lossGridOption;

  final List<int> lineUnitLoss;

  final double generalUnitConverter;
  final double generalCurrencyConverter;

  // lineUnitLosses: LineUnitLoss[];
  // lossClaims: LossClaim[];

  Loss({ required this.id, 
         required this.code, 
         required this.name, 
         required this.description, 
         required this.unit, 
         required this.order, 
         required this.lossGridOption, 
         required this.generalUnitConverter, 
         required this.generalCurrencyConverter,
         required this.lineUnitLoss });


  factory Loss.fromJson(Map<String, dynamic> json) {
    
    return Loss(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      unit: json['unit'],
      order: json['order'],
      lossGridOption: json['lossGridOption'],
      generalUnitConverter: json['generalUnitConverter'],
      generalCurrencyConverter: json['generalCurrencyConverter'],
      lineUnitLoss: json['lineUnitLoss']?.map((x) => x['lineUnitId']).toList(),
    );
  }
}
