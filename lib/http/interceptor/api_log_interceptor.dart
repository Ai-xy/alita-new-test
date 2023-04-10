part of http;

class ApiLogInterceptor extends Interceptor {
  DateTime startAt = DateTime.now();
  DateTime endAt = DateTime.now();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    startAt = DateTime.now();
    Log.i(
        "*********开始API请求：$startAt*************************请求路径:${AppConfig.env.baseUrl}${options.path}**************\n",
        tag: options.path);
    Log.i(
        "--------------请求query参数:${options.path}--->${options.queryParameters}------------------\n",
        tag: options.path);

    Log.i(
        "--------------请求formData参数:${options.path}--->${json.encode(options.data)}------------------\n",
        tag: options.path);

    Log.i(
        "--------------请求header参数:'${options.path}--->${options.headers}------------------\n",
        tag: options.path);
    // options.queryParameters.addAll({"access_session": session ?? ""});
    // super.onRequest(options, handler);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    endAt = DateTime.now();
    Log.i(
        "-----------结束API请求：$endAt 请求耗时：${endAt.millisecond - startAt.millisecond}ms------------请求结果：--------------------\n",
        tag: response.requestOptions.path);
    Log.i(jsonEncode(response.data), tag: response.requestOptions.path);

    super.onResponse(response, handler);
  }
}
