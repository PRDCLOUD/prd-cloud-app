part of 'production_stop_cubit.dart';

enum ProductionStopStatus{ updated, adding, deleting }

@immutable
class ProductionStopState extends Equatable {

  final int productionGroupId;
  final ProductionStopStatus status;
  final List<ProductionStop> stops;


  const ProductionStopState({required this.productionGroupId, required this.stops, required this.status});

  @override
  List<Object?> get props => [productionGroupId, status, stops];

  ProductionStopState copyWith({
    int? productionGroupId,
    ProductionStopStatus? status,
    List<ProductionStop>? stops,
  }) {
    return ProductionStopState(
      productionGroupId: productionGroupId ?? this.productionGroupId,
      status: status ?? this.status,
      stops: stops ?? this.stops,
    );
  }
}
