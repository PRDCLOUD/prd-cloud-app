part of 'preferences_cubit.dart';

@immutable
class UserPreferencesState extends Equatable {

  final List<String> selectedProductionLines;

  const UserPreferencesState({required this.selectedProductionLines});

  @override
  List<Object> get props => [selectedProductionLines];

  UserPreferencesState copyWith({
    String? tenant,
    List<String>? selectedProductionLines,
  }) {
    return UserPreferencesState(
      selectedProductionLines: selectedProductionLines ?? this.selectedProductionLines,
    );
  }
}
