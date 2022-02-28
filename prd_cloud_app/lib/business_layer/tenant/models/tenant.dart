import 'package:equatable/equatable.dart';

class Tenant extends Equatable {
  const Tenant(this.name);

  final String name;

  @override
  List<Object> get props => [name];

  static const empty = Tenant('-');
}