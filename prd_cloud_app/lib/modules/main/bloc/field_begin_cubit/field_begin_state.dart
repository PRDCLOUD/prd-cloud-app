part of 'field_begin_cubit.dart';

@immutable
class FieldBeginState extends Equatable {

  final int productionBasicDataId;
  final DateTime? fieldValue;

  const FieldBeginState({required this.productionBasicDataId, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, fieldValue];

  FieldBeginState copyWith({
    int? productionBasicDataId,
    DateTime? fieldValue,
  }) {
    return FieldBeginState(
      productionBasicDataId: productionBasicDataId ?? this.productionBasicDataId,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }
}
