part of 'field_variable_numeric_cubit.dart';

@immutable
class FieldVariableNumericState extends Equatable {

  final int productionBasicDataId;
  final int variableDataId;
  final String label;
  final int decimals;
  final double? fieldValue;

  const FieldVariableNumericState({required this.productionBasicDataId, required this.variableDataId, required this.label, required this.decimals, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, variableDataId, label, decimals, fieldValue];

  FieldVariableNumericState newFieldValue(double? fieldValue) {
    return FieldVariableNumericState(
      productionBasicDataId: productionBasicDataId,
      variableDataId: variableDataId,
      label: label,
      decimals: decimals,
      fieldValue: fieldValue
    );
  }
}
