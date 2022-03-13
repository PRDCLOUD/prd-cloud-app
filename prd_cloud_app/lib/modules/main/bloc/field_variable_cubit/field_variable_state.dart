part of 'field_variable_cubit.dart';

@immutable
class FieldVariableState extends Equatable {

  final int productionBasicDataId;
  final int variableDataId;
  final dynamic fieldValue;

  const FieldVariableState({required this.productionBasicDataId, required this.variableDataId, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, variableDataId, fieldValue];

  FieldVariableState copyWith({
    int? productionBasicDataId,
    int? variableDataId,
    dynamic fieldValue,
  }) {
    return FieldVariableState(
      productionBasicDataId: productionBasicDataId ?? this.productionBasicDataId,
      variableDataId: variableDataId ?? this.variableDataId,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }
}
