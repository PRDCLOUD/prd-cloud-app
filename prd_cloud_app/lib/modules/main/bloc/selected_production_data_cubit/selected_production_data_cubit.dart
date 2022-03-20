import 'package:bloc/bloc.dart';

class SelectedProductionDataCubit extends Cubit<int?> {
  SelectedProductionDataCubit() : super(null);

  selectProductionDataGroup(int id) {
    emit(id);
  }

  unselectProductionData() {
    emit(null);
  }

}
