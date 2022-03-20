part of 'pending_http_requests_cubit.dart';

@immutable
class PendingHttpRequestsState extends Equatable {

  final List<String> pendingHttpRequests;

  const PendingHttpRequestsState(this.pendingHttpRequests);

  @override
  List<Object> get props => [pendingHttpRequests];

  bool hasPendingRequests() => pendingHttpRequests.isNotEmpty;
}
