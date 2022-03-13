part of 'field_variable_text_cubit.dart';

@immutable
class FieldVariableTextState extends Equatable {

  final int productionBasicDataId;
  final int variableDataId;
  final bool enabled;
  final String label;
  final List<String>? options;
  final String? fieldValue;

  const FieldVariableTextState({required this.productionBasicDataId, required this.variableDataId, required this.label, required this.enabled, required this.fieldValue, required this.options});
  
  @override
  List<Object?> get props => [productionBasicDataId, variableDataId, fieldValue];

  FieldVariableTextState newFieldValue(String? fieldValue) {
    return FieldVariableTextState(
      productionBasicDataId: productionBasicDataId,
      variableDataId: variableDataId,
      label: label,
      enabled: enabled,
      options: options,
      fieldValue: fieldValue
    );
  }
}
