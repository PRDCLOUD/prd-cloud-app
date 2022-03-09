

part of 'open_production_data_cubit.dart';

@immutable
class OpenProductionDataState extends Equatable {

  final List<ProductionBasicData> items;
  
  const OpenProductionDataState(this.items);

  factory OpenProductionDataState.empty() => OpenProductionDataState(List.empty());

  OpenProductionDataState copyWith({ List<ProductionBasicData>? items }) {
    return OpenProductionDataState(items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}