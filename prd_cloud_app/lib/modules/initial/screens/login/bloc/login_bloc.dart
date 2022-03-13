import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final AuthenticationRepository _authenticationRepository;

  LoginBloc({required AuthenticationRepository authenticationRepository}) 
    : _authenticationRepository = authenticationRepository, super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

    void _onSubmitted(LoginSubmitted event,Emitter<LoginState> emit) async {
    emit(state.copyWith(status: SubmissionStatus.submissionInProgress));
    try {
      await _authenticationRepository.logIn();
      emit(state.copyWith(status: SubmissionStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: SubmissionStatus.submissionFailure));
    }
  }
}