part of 'field_end_cubit.dart';

@immutable
class FieldEndState extends Equatable {

  final int productionBasicDataId;
  final DateTime? fieldValue;

  const FieldEndState({required this.productionBasicDataId, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, fieldValue];

  FieldEndState copyWithNewFieldValue({DateTime? fieldValue}) {
    return FieldEndState(
      productionBasicDataId: productionBasicDataId,
      fieldValue: fieldValue,
    );
  }
}
