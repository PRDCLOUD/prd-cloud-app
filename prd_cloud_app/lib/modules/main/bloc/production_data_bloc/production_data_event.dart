part of 'production_data_bloc.dart';

@immutable
abstract class ProductionDataEvent {}

class ApontamentosRefreshEvent extends ProductionDataEvent {
  final int take;
  final List<String> prdLines;
  final ProductionDataStatus status;

  ApontamentosRefreshEvent({required this.prdLines, required this.status, required this.take});
}