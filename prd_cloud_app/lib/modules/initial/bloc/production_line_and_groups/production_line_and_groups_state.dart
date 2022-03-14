part of 'production_line_and_groups_cubit.dart';

enum ProductionLineAndGroupsLoadState { loaded, loading, unloaded }

@immutable
abstract class ProductionLineAndGroupsState extends Equatable {

  final ProductionLineAndGroupsLoadState productionLineAndGroupsLoadState;

  const ProductionLineAndGroupsState(this.productionLineAndGroupsLoadState);

  @override
  List<Object> get props => [productionLineAndGroupsLoadState];
}

class ProductionLineAndGroupUnloaded extends ProductionLineAndGroupsState {
  const ProductionLineAndGroupUnloaded() 
    : super (ProductionLineAndGroupsLoadState.unloaded);
}

class ProductionLineAndGroupLoading extends ProductionLineAndGroupsState {
  const ProductionLineAndGroupLoading() 
    : super (ProductionLineAndGroupsLoadState.loading);
}

class ProductionLineAndGroupLoaded extends ProductionLineAndGroupsState {

  final List<ProductionLineAndGroup> productionLineAndGroups;

  const ProductionLineAndGroupLoaded({ required this.productionLineAndGroups })
    : super (ProductionLineAndGroupsLoadState.loaded);

  @override
  List<Object> get props => [productionLineAndGroupsLoadState, productionLineAndGroups];
}