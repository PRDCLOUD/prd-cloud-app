import 'package:equatable/equatable.dart';
import 'package:models/src/utils/date_time_functions.dart';
import 'package:models/src/utils/optional.dart';
import 'package:timezone/timezone.dart' as tz;

enum DateTimeType { 
  DateTime, 
  Date, 
  Time 
}

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

    final DateTimeType? dateTimeType;
    final DateTime? dateTime;

    List<String>? get textOptionsList {
      if (textOptions == null || textOptions == "") {
        return null;
      } else {
        var list = textOptions!.split(';').toList();
        if (text != null && !list.contains(text)) {
          list.add(text!);
        }
        list.sort(((a, b) => a.compareTo(b)));
        return list;
      }
    }

    bool get isReadOnly {
      return typeVariableImplementation.toLowerCase() == 'default numeric value' || 
              typeVariableImplementation.toLowerCase() == 'default text value' ||
              typeVariableImplementation.toLowerCase() == 'numeric per product' ||
              typeVariableImplementation.toLowerCase() == 'text per product';
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
      required this.width,
      required this.dateTimeType,
      required this.dateTime
    });


    factory ProductionVariable.fromJson(Map<String, dynamic> json, tz.Location location) {
      
      DateTimeType? StringToDateTimeType(String? value) {
        switch (value?.toLowerCase()) {
          case "date": return DateTimeType.Date;
          case "datetime": return DateTimeType.DateTime;
          case "time": return DateTimeType.Time;
        }
        return null;
      }

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
        width: json['width'],
        dateTimeType: StringToDateTimeType(json['dateTimeType']),
        dateTime: DateTimeFunctions.parseDateTime(json['dateTime'] as String?, location)
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
      Optional<double?> value = const Optional(),
      Optional<String?> text = const Optional(),
      Optional<DateTime?> dateTime = const Optional(),
    }) {
      return ProductionVariable(
        id: id,
        definitionName: definitionName,
        implementationName: implementationName,
        implementationLabel: implementationLabel,
        lineUnitId: lineUnitId,
        productionBasicDataId: productionBasicDataId,
        required: required,
        typeVariableDefinition: typeVariableDefinition,
        typeVariableImplementation: typeVariableImplementation,
        variableCurrentImplementationId: variableCurrentImplementationId,
        variableFormulaIdentifier: variableFormulaIdentifier,
        decimalPlaces: decimalPlaces,
        value: value.valueOr(this.value),
        text: text.valueOr(this.text),
        textOptions: textOptions,
        rowOrder: rowOrder,
        columnOrder: columnOrder,
        width: width,
        dateTime: dateTime.valueOr(this.dateTime),
        dateTimeType: this.dateTimeType
      );
    }
}
