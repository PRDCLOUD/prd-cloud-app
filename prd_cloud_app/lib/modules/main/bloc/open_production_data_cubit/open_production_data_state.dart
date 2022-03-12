

part of 'open_production_data_cubit.dart';

@immutable
class OpenProductionDataState extends Equatable {

  final bool loadingItem;
  final List<ProductionBasicData> loadedItems;
  final ProductionBasicData? selectedItem;
  
  const OpenProductionDataState({required this.loadingItem, required this.loadedItems, this.selectedItem });

  factory OpenProductionDataState.empty() => OpenProductionDataState(loadingItem: false, loadedItems: List.empty(growable: true));

  OpenProductionDataState copyWith({bool? loadingItem, List<ProductionBasicData>? loadedItems, required ProductionBasicData? selectedItem}) {
    return OpenProductionDataState(
      loadingItem: loadingItem ?? this.loadingItem,
      loadedItems: loadedItems ?? this.loadedItems,
      selectedItem: selectedItem
    );
  }

  @override
  List<Object?> get props => [loadingItem, selectedItem, loadedItems];
}
