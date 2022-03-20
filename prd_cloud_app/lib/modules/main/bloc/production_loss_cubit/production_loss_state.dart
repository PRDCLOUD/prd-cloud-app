part of 'production_loss_cubit.dart';

enum ProductionLossStatus{ updated, adding, deleting }

@immutable
class ProductionLossState extends Equatable {

  final int productionGroupId;
  final ProductionLossStatus status;
  final List<ProductionLoss> losses;


  const ProductionLossState({required this.productionGroupId, required this.losses, required this.status});

  @override
  List<Object?> get props => [productionGroupId, status, losses];

  ProductionLossState copyWith({
    ProductionLossStatus? status,
    List<ProductionLoss>? losses,
  }) {
    return ProductionLossState(
      productionGroupId: productionGroupId,
      status: status ?? this.status,
      losses: losses ?? this.losses,
    );
  }
}
