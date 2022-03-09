part of 'production_data_bloc.dart';

enum ProductionDataLoadState { loading, loaded, notLoaded }

class ProductionDataState extends Equatable {
  const ProductionDataState._(this.status, this.loadedResult);

  ProductionDataState.notLoaded() : this._(ProductionDataLoadState.notLoaded, List.empty());

  ProductionDataState.loading() : this._(ProductionDataLoadState.loading, List.empty());

  const ProductionDataState.loaded(List<dynamic> loadedResult) : this._(ProductionDataLoadState.loaded, loadedResult);

  final ProductionDataLoadState status;
  final List<dynamic> loadedResult;

  @override
  List<Object> get props => [status, loadedResult];
}
