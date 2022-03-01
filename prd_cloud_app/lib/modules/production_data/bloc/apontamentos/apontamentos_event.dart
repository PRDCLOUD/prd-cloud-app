part of 'apontamentos_bloc.dart';

@immutable
abstract class ApontamentosEvent {}

class ApontamentosRefreshEvent extends ApontamentosEvent {
  final int take;

  ApontamentosRefreshEvent({required this.take});
}