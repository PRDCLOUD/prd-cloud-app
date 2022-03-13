import 'package:bloc/bloc.dart';

class SelectedProductionDataCubit extends Cubit<int?> {
  SelectedProductionDataCubit() : super(null);

  selectProductionData(int id) {
    emit(id);
  }

  unselectProductionData() {
    emit(null);
  }

}
