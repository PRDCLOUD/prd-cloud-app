import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:production_data_repository/production_data_repository.dart';

class SelectedProductionDataCubit extends Cubit<int?> {
  SelectedProductionDataCubit({
    required OpenProductionDataRepository openProductionDataRepository,
  }) : 
    _openProductionDataRepository = openProductionDataRepository, 
  super(null) {
    _lastSelectedSubscription = _openProductionDataRepository.lastLoadedStream().listen((lastLoaded) {
      emit(lastLoaded);
    });
  }

  final OpenProductionDataRepository _openProductionDataRepository;
  late StreamSubscription<int?> _lastSelectedSubscription;

  selectProductionDataGroup(int id) {
    emit(id);
  }

  unselectProductionData() {
    emit(null);
  }

  @override
  Future<void> close() {
    _lastSelectedSubscription.cancel();
    return super.close();
  }

}
