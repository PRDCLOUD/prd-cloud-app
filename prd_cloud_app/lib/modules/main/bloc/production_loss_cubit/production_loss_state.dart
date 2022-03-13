part of 'production_loss_cubit.dart';

enum ProductionLossStatus{ updated, adding, deleting }

@immutable
class ProductionLossState extends Equatable {

  final int productionBasicDataId;
  final ProductionLossStatus status;
  final List<ProductionLoss> losses;


  const ProductionLossState({required this.productionBasicDataId, required this.losses, required this.status});

  @override
  List<Object?> get props => [productionBasicDataId, status, losses];

  ProductionLossState copyWith({
    int? productionBasicDataId,
    ProductionLossStatus? status,
    List<ProductionLoss>? losses,
  }) {
    return ProductionLossState(
      productionBasicDataId: productionBasicDataId ?? this.productionBasicDataId,
      status: status ?? this.status,
      losses: losses ?? this.losses,
    );
  }
}
