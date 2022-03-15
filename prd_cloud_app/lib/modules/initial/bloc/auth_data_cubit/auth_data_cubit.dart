import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

class AuthDataCubit extends Cubit<AuthData?> {
  AuthDataCubit({
    required AuthenticationRepository authenticationRepository, 
  }) : super(null) {
     _authDataRepositorySubscription = authenticationRepository.authData.listen((event) {
      emit(event);
    });
  }

  late StreamSubscription<dynamic> _authDataRepositorySubscription;

  @override
  Future<void> close() {
    _authDataRepositorySubscription.cancel();
    return super.close();
  }

}
