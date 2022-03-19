part of 'field_variable_numeric_cubit.dart';

@immutable
class FieldVariableNumericState extends Equatable {

  final int productionBasicDataId;
  final int variableDataId;
  final String label;
  final bool required;
  final bool enabled;
  final int decimals;
  final double? fieldValue;

  const FieldVariableNumericState({required this.productionBasicDataId, required this.variableDataId, required this.label, required this.enabled, required this.decimals, required this.fieldValue, required this.required});
  
  @override
  List<Object?> get props => [productionBasicDataId, variableDataId, label, decimals, fieldValue];

  FieldVariableNumericState newFieldValue(double? fieldValue) {
    return FieldVariableNumericState(
      productionBasicDataId: productionBasicDataId,
      variableDataId: variableDataId,
      label: label,
      required: required,
      enabled: enabled,
      decimals: decimals,
      fieldValue: fieldValue
    );
  }
}
