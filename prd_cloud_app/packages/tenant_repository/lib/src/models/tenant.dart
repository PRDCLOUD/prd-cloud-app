class Tenant {
  const Tenant(this.name);

  final String name;

  @override
  List<Object> get props => [name];

  static const empty = Tenant('-');
}