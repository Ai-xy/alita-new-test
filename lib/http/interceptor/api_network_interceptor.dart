part of http;

class ApiNetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        handler.reject(DioError(
          requestOptions: options,
          error: '网络状态异常',
          type: DioErrorType.connectTimeout,
        ));
      } else {
        super.onRequest(options, handler);
      }
    });
  }
}
