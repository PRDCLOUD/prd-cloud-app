part of 'field_begin_cubit.dart';

@immutable
class FieldBeginState<T> extends Equatable {

  final int productionBasicDataId;
  final T fieldValue;

  const FieldBeginState({required this.productionBasicDataId, required this.fieldValue});
  
  @override
  List<Object?> get props => [productionBasicDataId, fieldValue];

  FieldBeginState<T> copyWith({
    int? productionBasicDataId,
    T? fieldValue,
  }) {
    return FieldBeginState<T>(
      productionBasicDataId: productionBasicDataId ?? this.productionBasicDataId,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }
}
