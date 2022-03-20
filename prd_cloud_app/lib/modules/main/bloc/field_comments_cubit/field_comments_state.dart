part of 'field_comments_cubit.dart';

@immutable
class FieldCommentsState extends Equatable {

  final int productionBasicDataId;
  final String? fieldValue;

  const FieldCommentsState({required this.productionBasicDataId, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, fieldValue];

  FieldCommentsState copyWithNewFieldValue({String? fieldValue}) {
    return FieldCommentsState(
      productionBasicDataId: productionBasicDataId,
      fieldValue: fieldValue,
    );
  }
}
