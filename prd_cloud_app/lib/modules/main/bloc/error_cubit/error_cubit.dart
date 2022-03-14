import 'package:bloc/bloc.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/cupertino.dart';

part 'error_state.dart';

class ErrorCubit extends Cubit<ErrorState> {
  ErrorCubit({
    required ErrorRepository errorRepository, 
  }) : _errorRepository = errorRepository, super(const ErrorState(null)) {
    _errorRepository.errorStream().listen((event) {
      emit(ErrorState(event));
    });
  }

  final ErrorRepository _errorRepository;


}
