

part of 'selected_production_line_and_groups_cubit.dart';

@immutable
class SelectedProductionLineAndGroupsState extends Equatable {

  final List<ProductionLineAndGroup> selectedProductionLinesAndGroups;

  const SelectedProductionLineAndGroupsState(this.selectedProductionLinesAndGroups);

  bool isSelected(ProductionLineAndGroup item) => selectedProductionLinesAndGroups.contains(item);

  @override
  List<Object> get props => [selectedProductionLinesAndGroups];

  SelectedProductionLineAndGroupsState copyWith({
    List<ProductionLineAndGroup>? selectedProductionLinesAndGroups,
  }) {
    return SelectedProductionLineAndGroupsState(
      selectedProductionLinesAndGroups ?? this.selectedProductionLinesAndGroups,
    );
  }
}
