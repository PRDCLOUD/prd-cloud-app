import 'dart:async';

import 'models/models.dart';

class ApontamentosRepository {
  Apontamento? _user;

  Future<Apontamento?> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = Apontamento('aa'),
    );
  }
}