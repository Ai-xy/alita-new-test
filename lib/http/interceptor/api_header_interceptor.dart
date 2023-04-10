part of http;

class ApiHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(
      {
        "Content-Type": 'application/json;charset=UTF-8',
        'language': AppConfig.appLanguage.tag,
        'loginToken': AppLocalStorage.getString(AppStorageKey.token),
        'appId': AppConfig.env.appId,
        'sign': _sign(options.method == 'POST'
            ? options.data is Map
                ? options.data
                : {}
            : options.queryParameters),
      },
    );
    super.onRequest(options, handler);
  }

  String _sign(Map data) {
    String str = '';
    List<dynamic> keys = data.keys.toList();
    keys.sort();
    for (var key in keys) {
      var value = data[key];
      if (value is List && value.isNotEmpty) {
        if (value[0] is String) {
          value = '["${value.join('","')}"]';
        } else {
          value = '[${value.join(',')}]';
        }
      }
      str = '$str$key$value';
    }
    return _generateMd5('$str${AppConfig.env.appId}').toUpperCase();
  }

  static String _generateMd5(String data) {
    final Uint8List content = const Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    const HexCodec hexCodec = HexCodec();
    return hexCodec.encode(digest.bytes);
  }
}
