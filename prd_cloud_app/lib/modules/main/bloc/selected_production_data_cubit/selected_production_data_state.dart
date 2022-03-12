

part of 'selected_production_data_cubit.dart';

@immutable
class SelectedProductionDataState extends Equatable {

  final ProductionBasicData? selectedItem;
  
  const SelectedProductionDataState(this.selectedItem);



  @override
  List<Object?> get props => [selectedItem];
}
