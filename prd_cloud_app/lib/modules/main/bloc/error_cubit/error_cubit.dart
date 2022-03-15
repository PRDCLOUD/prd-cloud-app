import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/material.dart';

part 'error_state.dart';

class ErrorCubit extends Cubit<ErrorState> {
  ErrorCubit({
    required ErrorRepository errorRepository, 
  }) : _errorRepository = errorRepository, super(const ErrorState(null)) {
     _errorRepositorySubscription = _errorRepository.errorStream().listen((event) {
      emit(ErrorState(event));
    });
  }

  final ErrorRepository _errorRepository;
  late StreamSubscription<dynamic> _errorRepositorySubscription;

  @override
  Future<void> close() {
    _errorRepositorySubscription.cancel();
    return super.close();
  }

}
