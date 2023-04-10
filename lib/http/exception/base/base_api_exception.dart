part of http;

abstract class BaseApiException extends DioError {
  BaseApiException({required super.requestOptions, super.response});

  void onException();
}
