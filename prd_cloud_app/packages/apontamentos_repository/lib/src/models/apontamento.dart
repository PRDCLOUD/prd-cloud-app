import 'package:equatable/equatable.dart';

class Apontamento extends Equatable {
  const Apontamento(this.id);

  final String id;

  @override
  List<Object> get props => [id];

  static const empty = Apontamento('-');
}