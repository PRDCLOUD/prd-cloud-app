part of 'apontamentos_bloc.dart';

enum ApontamentosLoadState { loading, loaded, notLoaded }

class ApontamentosState extends Equatable {
  const ApontamentosState._(this.status, this.loadedResult);

  ApontamentosState.notLoaded() : this._(ApontamentosLoadState.notLoaded, List.empty());

  ApontamentosState.loading() : this._(ApontamentosLoadState.loading, List.empty());

  const ApontamentosState.loaded(List<dynamic> loadedResult) : this._(ApontamentosLoadState.loaded, loadedResult);

  final ApontamentosLoadState status;
  final List<dynamic> loadedResult;

  @override
  List<Object> get props => [status, loadedResult];
}
