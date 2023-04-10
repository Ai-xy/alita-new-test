part of http;

class ApiArgInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final Map extra = {
      'deviceNo': AppConfig.deviceId,
      'deviceType': '',
      'osType': Platform.isAndroid ? 'AOS' : 'IOS',
    };
    if (options.method == 'GET') {
      options.queryParameters = {...options.queryParameters, ...extra};
    }
    if (options.method == 'POST' && options.data is Map) {
      options.data = {...options.data, ...extra};
    }
    super.onRequest(options, handler);
  }
}
