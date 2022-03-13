import 'package:equatable/equatable.dart';

class ProductionVariable extends Equatable {

    final int id;

    final String definitionName;
    final String implementationName;
    final String implementationLabel;
    final int lineUnitId;
    final int productionBasicDataId;
    final bool required;
    final String typeVariableDefinition;
    final String typeVariableImplementation;
    final int variableCurrentImplementationId;
    final String variableFormulaIdentifier;

    final int? decimalPlaces;
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

  @override
  List<Object?> get props {
    return [
      id,
      definitionName,
      implementationName,
      implementationLabel,
      lineUnitId,
      productionBasicDataId,
      required,
      typeVariableDefinition,
      typeVariableImplementation,
      variableCurrentImplementationId,
      variableFormulaIdentifier,
      decimalPlaces,
      value,
      text,
      textOptions,
      rowOrder,
      columnOrder,
      width,
    ];
  }

  ProductionVariable copyWith({
    int? id,
    String? definitionName,
    String? implementationName,
    String? implementationLabel,
    int? lineUnitId,
    int? productionBasicDataId,
    bool? required,
    String? typeVariableDefinition,
    String? typeVariableImplementation,
    int? variableCurrentImplementationId,
    String? variableFormulaIdentifier,
    int? decimalPlaces,
    double? value,
    String? text,
    String? textOptions,
    int? rowOrder,
    int? columnOrder,
    int? width,
  }) {
    return ProductionVariable(
      id: id ?? this.id,
      definitionName: definitionName ?? this.definitionName,
      implementationName: implementationName ?? this.implementationName,
      implementationLabel: implementationLabel ?? this.implementationLabel,
      lineUnitId: lineUnitId ?? this.lineUnitId,
      productionBasicDataId: productionBasicDataId ?? this.productionBasicDataId,
      required: required ?? this.required,
      typeVariableDefinition: typeVariableDefinition ?? this.typeVariableDefinition,
      typeVariableImplementation: typeVariableImplementation ?? this.typeVariableImplementation,
      variableCurrentImplementationId: variableCurrentImplementationId ?? this.variableCurrentImplementationId,
      variableFormulaIdentifier: variableFormulaIdentifier ?? this.variableFormulaIdentifier,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      value: value ?? this.value,
      text: text ?? this.text,
      textOptions: textOptions ?? this.textOptions,
      rowOrder: rowOrder ?? this.rowOrder,
      columnOrder: columnOrder ?? this.columnOrder,
      width: width ?? this.width,
    );
  }
}
