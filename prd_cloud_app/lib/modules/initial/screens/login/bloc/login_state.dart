part of 'login_bloc.dart';

enum SubmissionStatus { none, submissionInProgress, submissionSuccess, submissionFailure }

class LoginState extends Equatable {
  const LoginState({this.status = SubmissionStatus.none});

  final SubmissionStatus status;

  LoginState copyWith({SubmissionStatus? status}) {
    return LoginState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}