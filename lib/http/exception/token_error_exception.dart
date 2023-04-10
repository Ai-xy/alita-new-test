import 'package:alita/http/http.dart';

class TokenErrorException extends BaseApiException {
  TokenErrorException({required super.requestOptions});

  @override
  void onException() {
    // TODO: implement onException
  }
}
