import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesRepository {

  final String _tenant;
  final String _userId;
  String get _selectedProductionLinesKey => _tenant + '|' + _userId + '|selected-production-lines';

  UserPreferencesRepository({required String userId, required String tenant}) : _tenant = tenant, _userId = userId;

  Future<void> setSelectedProductionLine(List<String> selectedProductionLine) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedProductionLinesKey, selectedProductionLine);
  }

  Future<List<String>> getSelectedProductionLine() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getStringList(_selectedProductionLinesKey) ?? List<String>.empty();
  }

}