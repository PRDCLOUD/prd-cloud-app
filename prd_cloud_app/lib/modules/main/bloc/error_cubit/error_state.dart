part of 'error_cubit.dart';

@immutable
class ErrorState extends Equatable {

  final String? errorMessage;

  const ErrorState(this.errorMessage);
  
  @override
  List<Object?> get props => [errorMessage];

}
