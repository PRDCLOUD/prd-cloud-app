import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'open_production_data_state.dart';

class OpenProductionDataCubit extends Cubit<OpenProductionDataState> {
  OpenProductionDataCubit() : super(OpenProductionDataInitial());

  // final _productionDataRepository;
}
