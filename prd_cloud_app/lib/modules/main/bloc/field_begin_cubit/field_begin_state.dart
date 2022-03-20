part of 'field_begin_cubit.dart';

@immutable
class FieldBeginState extends Equatable {

  final int productionBasicDataId;
  final DateTime? fieldValue;

  const FieldBeginState({required this.productionBasicDataId, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, fieldValue];

  FieldBeginState copyWithNewFieldValue({DateTime? fieldValue}) {
    return FieldBeginState(
      productionBasicDataId: productionBasicDataId,
      fieldValue: fieldValue,
    );
  }
}
