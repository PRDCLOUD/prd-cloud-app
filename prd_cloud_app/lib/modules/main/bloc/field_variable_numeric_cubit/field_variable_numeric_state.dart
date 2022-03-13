part of 'field_variable_numeric_cubit.dart';

@immutable
class FieldVariableNumericState extends Equatable {

  final int productionBasicDataId;
  final int variableDataId;
  final String label;
  final double? fieldValue;

  const FieldVariableNumericState({required this.productionBasicDataId, required this.variableDataId, required this.label, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, variableDataId, label, fieldValue];

  FieldVariableNumericState newFieldValue(double? fieldValue) {
    return FieldVariableNumericState(
      productionBasicDataId: productionBasicDataId,
      variableDataId: variableDataId,
      label: label,
      fieldValue: fieldValue
    );
  }
}
