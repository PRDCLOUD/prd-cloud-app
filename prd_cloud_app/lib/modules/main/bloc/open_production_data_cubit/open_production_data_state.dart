

part of 'open_production_data_cubit.dart';

@immutable
class OpenProductionDataState extends Equatable {

  final bool loadingItem;
  final List<ProductionBasicData> loadedItems;
  
  const OpenProductionDataState({required this.loadingItem, required this.loadedItems });

  factory OpenProductionDataState.empty() => OpenProductionDataState(loadingItem: false, loadedItems: List.empty());

  OpenProductionDataState copyWith({bool? loadingItem, List<ProductionBasicData>? loadedItems}) {
    return OpenProductionDataState(
      loadingItem: loadingItem ?? this.loadingItem,
      loadedItems: loadedItems ?? this.loadedItems,
    );
  }

  @override
  List<Object?> get props => [loadingItem, loadedItems];
}
