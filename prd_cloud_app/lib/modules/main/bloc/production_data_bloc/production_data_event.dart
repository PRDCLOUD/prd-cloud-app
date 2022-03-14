part of 'production_data_bloc.dart';

@immutable
abstract class ProductionDataEvent {}

class ApontamentosRefreshEvent extends ProductionDataEvent {
  final ProductionDataFilter filter;

  ApontamentosRefreshEvent({required this.filter});
}