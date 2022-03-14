part of 'production_data_cubit.dart';

enum ProductionDataLoadState { loading, loaded, notLoaded }

class ProductionDataState extends Equatable {
  const ProductionDataState._(this.status, this.loadedResult, this.filter);

  ProductionDataState.notLoaded() : this._(ProductionDataLoadState.notLoaded, List.empty(), null);

  ProductionDataState.loading(ProductionDataFilter filter) : this._(ProductionDataLoadState.loading, List.empty(), filter);

  const ProductionDataState.loaded(List<dynamic> loadedResult, ProductionDataFilter filter) : this._(ProductionDataLoadState.loaded, loadedResult, filter);

  final ProductionDataFilter? filter;
  final ProductionDataLoadState status;
  final List<dynamic> loadedResult;

  @override
  List<Object> get props => [status, loadedResult];
}
