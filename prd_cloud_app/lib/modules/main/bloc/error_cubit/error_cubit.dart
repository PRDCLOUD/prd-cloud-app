import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'error_state.dart';

class ErrorCubit extends Cubit<ErrorState> {
  ErrorCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
  }) : _openProductionDataRepository = openProductionDataRepository, super(const ErrorState(null)) {
    _openProductionDataRepository.errorStream().listen((event) {
      emit(ErrorState(event));
    });
  }

  final OpenProductionDataRepository _openProductionDataRepository;


}
