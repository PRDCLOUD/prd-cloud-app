part of 'production_data_list_cubit.dart';

enum ProductionDataLoadState { loading, loaded, notLoaded }

class ProductionDataState extends Equatable {
  const ProductionDataState._(this.status, this.loadedResult, this.filter);

  ProductionDataState.notLoaded() : this._(ProductionDataLoadState.notLoaded, List.empty(), null);

  ProductionDataState.loading(ProductionDataFilter filter, [ List<ProductionItemOfList>? loadedResult ]) : this._(ProductionDataLoadState.loading, loadedResult ?? List.empty(), filter);

  const ProductionDataState.loaded(ProductionDataFilter filter, List<ProductionItemOfList> loadedResult) : this._(ProductionDataLoadState.loaded, loadedResult, filter);

  final ProductionDataFilter? filter;
  final ProductionDataLoadState status;
  final List<ProductionItemOfList> loadedResult;

  @override
  List<Object> get props => [status, loadedResult];
}
