part of http;

class ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dynamic data = response.data;
    if (data is! Map) {
      throw ErrorDataFormataException(requestOptions: response.requestOptions);
    }
    final String code = data['code'];
    final ApiCode apiCode = getApiCodeByString(code);
    String message = data['message'] ?? '';

    if (apiCode.isError && message.isNotEmpty) {
      message =
          '${message.toLowerCase().replaceAll('.', ' ').capitalizeFirst ?? ''} !';
      AppToast.alert(message: message);
      handler.reject(
          DioError(requestOptions: response.requestOptions, error: apiCode),
          true);
      throw DioError(requestOptions: response.requestOptions, error: apiCode);
    }
    super.onResponse(response, handler);
  }
}
