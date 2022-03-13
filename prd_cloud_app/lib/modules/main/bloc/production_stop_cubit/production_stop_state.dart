part of 'production_stop_cubit.dart';

enum ProductionStopStatus{ updated, adding, deleting }

@immutable
class ProductionStopState extends Equatable {

  final int productionBasicDataId;
  final ProductionStopStatus status;
  final List<ProductionStop> stops;


  const ProductionStopState({required this.productionBasicDataId, required this.stops, required this.status});

  @override
  List<Object?> get props => [productionBasicDataId, status, stops];

  ProductionStopState copyWith({
    int? productionBasicDataId,
    ProductionStopStatus? status,
    List<ProductionStop>? stops,
  }) {
    return ProductionStopState(
      productionBasicDataId: productionBasicDataId ?? this.productionBasicDataId,
      status: status ?? this.status,
      stops: stops ?? this.stops,
    );
  }
}
