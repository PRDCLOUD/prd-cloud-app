import 'dart:async';

class ErrorRepository {

  final _errorsDataStreamController = StreamController<dynamic>.broadcast();

  Stream<dynamic> errorStream() async* {
    yield null;
    yield* _errorsDataStreamController.stream;
  }

  communicateError(dynamic error) {
    if (_errorsDataStreamController.hasListener) {
      _errorsDataStreamController.add(error);
    }
  }

}