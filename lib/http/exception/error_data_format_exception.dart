import 'package:alita/http/http.dart';

class ErrorDataFormataException extends BaseApiException {
  ErrorDataFormataException({required super.requestOptions});

  @override
  void onException() {}
}
