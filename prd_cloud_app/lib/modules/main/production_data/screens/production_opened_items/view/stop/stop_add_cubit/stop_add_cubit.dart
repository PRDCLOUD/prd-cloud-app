import 'package:bloc/bloc.dart';

class StopAddCubit extends Cubit<DateTime> {
  StopAddCubit() : super(DateTime.now());

  void addStop() {
    emit(DateTime.now());
  }
}
