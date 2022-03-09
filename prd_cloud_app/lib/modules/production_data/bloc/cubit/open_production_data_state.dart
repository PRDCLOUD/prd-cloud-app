

part of 'open_production_data_cubit.dart';

class OpenProductionDataState {
  final List<ProductionBasicData> items;
  OpenProductionDataState(this.items);

  factory OpenProductionDataState.empty() => OpenProductionDataState(List.empty());

  OpenProductionDataState copyWith({ List<ProductionBasicData>? items }) {
    return OpenProductionDataState(items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}