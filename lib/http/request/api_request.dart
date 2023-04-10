part of http;

class ApiRequest {
  String path;
  Map<String, dynamic>? query;
  dynamic formData;
  Options? options;
  CancelToken? cancelToken;

  ProgressCallback? onSendProgress;
  ProgressCallback? onReceiveProgress;

  ///是否显示加载 一般在post提交时 置为true
  bool? withLoading;
  bool? withToken;
  bool? withToast;

  ApiRequest(
    this.path, {
    this.query,
    this.formData,
    this.cancelToken,
    this.options,
    this.withLoading = false,
    this.onReceiveProgress,
    this.onSendProgress,
    this.withToken = true,
    this.withToast = true,
  });
}
