import 'package:models/src/line_unit.dart';

class ProductionVariable {

    final int id;

    final String definitionName;
    final String implementationName;
    final String implementationLabel;
    final int lineUnitId;
    final LineUnit lineUnit;
    final int productionBasicDataId;
    final bool required;
    final String typeVariableDefinition;
    final String typeVariableImplementation;
    final int variableCurrentImplementationId;
    final String variableFormulaIdentifier;

    final double decimalPlaces;
    final double? value;
    
    final String? text;
    final String? textOptions;

    final int rowOrder;
    final int columnOrder;
    final int width;

    List<String> get textOptionsList {
      return textOptions?.split(';') ?? List.empty();
    }

    ProductionVariable({ 
      required this.id, 
      required this.definitionName, 
      required this.implementationName, 
      required this.implementationLabel, 
      required this.lineUnitId, 
      required this.lineUnit, 
      required this.productionBasicDataId, 
      required this.required, 
      required this.typeVariableDefinition, 
      required this.typeVariableImplementation, 
      required this.variableCurrentImplementationId, 
      required this.variableFormulaIdentifier, 
      required this.decimalPlaces, 
      required this.value, 
      required this.text, 
      required this.textOptions, 
      required this.rowOrder, 
      required this.columnOrder, 
      required this.width 
    });


    factory ProductionVariable.fromJson(Map<String, dynamic> json) {
      
      return ProductionVariable(
        id: json['id'],
        columnOrder: json['columnOrder'],
        decimalPlaces: json['decimalPlaces'],
        definitionName: json['definitionName'],
        implementationLabel: json['implementationLabel'] != Null ? json['implementationLabel'] : json['implementationName'],
        implementationName: json['implementationName'],
        lineUnit: LineUnit.fromJson(json['lineUnit']),
        lineUnitId: json['lineUnitId'],
        productionBasicDataId: json['productionBasicDataId'],
        required: json['required'],
        rowOrder: json['rowOrder'],
        text: json['text'],
        textOptions: json['textOptions'],
        typeVariableDefinition: json['typeVariableDefinition'],
        typeVariableImplementation: json['typeVariableImplementation'],
        value: json['value'],
        variableCurrentImplementationId: json['variableCurrentImplementationId'],
        variableFormulaIdentifier: json['variableFormulaIdentifier'],
        width: json['width']
      );
    }
}
