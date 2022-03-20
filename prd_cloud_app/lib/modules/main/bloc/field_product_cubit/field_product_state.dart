part of 'field_product_cubit.dart';

@immutable
class FieldProductState extends Equatable {

  final int productionBasicDataId;
  final int? fieldValue;

  const FieldProductState({required this.productionBasicDataId, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, fieldValue];

  FieldProductState copyWithNewFieldValue({int? fieldValue}) {
    return FieldProductState(
      productionBasicDataId: productionBasicDataId,
      fieldValue: fieldValue,
    );
  }
}
