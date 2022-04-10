part of 'field_variable_datetime_cubit.dart';

@immutable
class FieldVariableDateTimeState extends Equatable {

  final int productionBasicDataId;
  final int variableDataId;
  final bool enabled;
  final String label;
  final bool required;
  final DateTimeType? dateTimeType;
  final DateTime? fieldValue;

  const FieldVariableDateTimeState({required this.productionBasicDataId, required this.variableDataId, required this.label, required this.enabled, required this.fieldValue, required this.dateTimeType, required this.required});
  
  @override
  List<Object?> get props => [productionBasicDataId, variableDataId, fieldValue];

  FieldVariableDateTimeState newFieldValue(DateTime? fieldValue) {
    return FieldVariableDateTimeState(
      productionBasicDataId: productionBasicDataId,
      variableDataId: variableDataId,
      label: label,
      required: required,
      enabled: enabled,
      dateTimeType: dateTimeType,
      fieldValue: fieldValue
    );
  }
}
