import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'pending_http_requests_state.dart';

class PendingHttpRequestsCubit extends Cubit<PendingHttpRequestsState> {
  PendingHttpRequestsCubit({required OpenProductionDataRepository openProductionDataRepository}) : super(PendingHttpRequestsState(List.empty())) {
    _pendingHttpRequestsSubscription = openProductionDataRepository.pendingHttpRequestsStream().listen((event) {
      emit(PendingHttpRequestsState(event));
    });
  }

  late StreamSubscription<List<String>> _pendingHttpRequestsSubscription;

  @override
  Future<void> close() {
    _pendingHttpRequestsSubscription.cancel();
    return super.close();
  }

}
