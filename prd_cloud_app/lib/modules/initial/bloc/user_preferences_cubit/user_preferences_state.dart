part of 'user_preferences_cubit.dart';

@immutable
class UserPreferencesState extends Equatable {

  final List<String> selectedProductionLines;

  const UserPreferencesState({required this.selectedProductionLines});

  @override
  List<Object> get props => [selectedProductionLines];

  UserPreferencesState copyWith({List<String>? selectedProductionLines}) {
    return UserPreferencesState(
      selectedProductionLines: selectedProductionLines ?? this.selectedProductionLines,
    );
  }
}
