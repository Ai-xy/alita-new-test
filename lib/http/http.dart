library http;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alita/config/app_config.dart';
import 'package:alita/http/exception/error_data_format_exception.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:hex/hex.dart';

part 'code/api_code.dart';

///Request Response
part 'request/api_request.dart';
part 'response/api_response.dart';

///异常
part 'exception/base/base_api_exception.dart';

///拦截器
part 'interceptor/api_header_interceptor.dart';
part 'interceptor/api_network_interceptor.dart';
part 'interceptor/api_log_interceptor.dart';
part 'interceptor/api_arg_interceptor.dart';
part 'interceptor/api_repsonse_interceptor.dart';

class Http {
  static Http instance = Http._internal();

  factory Http() => instance;

  late final Dio dio;

  Http._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.env.baseUrl,
        // connectTimeout: 1000 * 30,
        receiveTimeout: 1000 * 10,
        validateStatus: (int? status) {
          return status != null && status > 0;
        },
      ),
    );
    dio.interceptors.addAll([
      ApiHeaderInterceptor(),
      ApiLogInterceptor(),
      ApiNetworkInterceptor(),
      ApiResponseInterceptor(),
    ]);
  }

  final CancelToken _cancelToken = CancelToken();

  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  ApiResponse _onData(Response response) {
    final data = response.data;

    ///返回空字符串同样视为操作成功
    if (data is String && data.isEmpty) {
      return ApiResponse.empty();
    }
    return ApiResponse.fromJson(data);
  }

  _onError(dynamic error, StackTrace s) {
    if (error is DioError) {
      error = error.error;
      if (error is BaseApiException) {
        Log.e(
          'Api请求报错====${error.requestOptions.method}====请求路径:${error.requestOptions.path}\n请求Query参数:${error.requestOptions.queryParameters}\n请求FormData参数:${error.requestOptions.data}====',
          error: error,
          stackTrace: s,
          tag: 'API',
        );
        error.onException();
        return;
      }
    }
    return error;
  }

  Future<ApiResponse> get(ApiRequest request) {
    Options requestOptions = request.options ?? Options();

    requestOptions = requestOptions.copyWith(extra: {
      "withToken": request.withToken,
      "withToast": request.withToast,
      "withLoading": request.withLoading,
    });

    return dio
        .get(
          request.path,
          cancelToken: request.cancelToken ?? _cancelToken,
          queryParameters: request.query,
          onReceiveProgress: request.onReceiveProgress,
          options: requestOptions,
        )
        .then(_onData, onError: _onError);
  }

  Future<ApiResponse> post(ApiRequest request) {
    Options requestOptions = request.options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "withToken": request.withToken,
      "withToast": request.withToast,
      "withLoading": request.withLoading,
    });

    return dio
        .post(
          request.path,
          data: request.formData,
          queryParameters: request.query,
          options: requestOptions,
          cancelToken: request.cancelToken ?? _cancelToken,
          onReceiveProgress: request.onReceiveProgress,
          onSendProgress: request.onSendProgress,
        )
        .timeout(const Duration(seconds: 5))
        .then(_onData, onError: _onError);
  }

  Future<ApiResponse> put(ApiRequest request) {
    Options requestOptions = request.options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "withToken": request.withToken,
      "withToast": request.withToast,
      "withLoading": request.withLoading,
    });
    return dio
        .put(
          request.path,
          data: request.formData,
          queryParameters: request.query,
          options: requestOptions,
          cancelToken: request.cancelToken ?? _cancelToken,
          onReceiveProgress: request.onReceiveProgress,
          onSendProgress: request.onReceiveProgress,
        )
        .then(_onData, onError: _onError);
  }

  Future<ApiResponse> patch(ApiRequest request) {
    return dio
        .patch(
          request.path,
          data: request.formData,
          queryParameters: request.query,
          options: request.options,
          cancelToken: request.cancelToken ?? _cancelToken,
          onReceiveProgress: request.onReceiveProgress,
          onSendProgress: request.onReceiveProgress,
        )
        .then(_onData, onError: _onError);
  }

  Future<ApiResponse> delete(ApiRequest request) {
    Options requestOptions = request.options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "withToken": request.withToken,
      "withToast": request.withToast,
      "withLoading": request.withLoading,
    });
    return dio
        .delete(request.path,
            data: request.formData,
            queryParameters: request.query,
            options: requestOptions,
            cancelToken: request.cancelToken ?? _cancelToken)
        .then(_onData, onError: _onError);
  }

  Future<ApiResponse> postForm(ApiRequest request) {
    return dio
        .put(
          request.path,
          data: request.formData,
          queryParameters: request.query,
          options: request.options,
          cancelToken: request.cancelToken ?? _cancelToken,
          onReceiveProgress: request.onReceiveProgress,
          onSendProgress: request.onReceiveProgress,
        )
        .then(_onData, onError: _onError);
  }

  Future download(ApiRequest request, {required String filePath}) {
    return dio.download(
      request.path,
      filePath,
      data: request.formData,
      queryParameters: request.query,
      options: request.options,
      cancelToken: request.cancelToken ?? _cancelToken,
      onReceiveProgress: request.onReceiveProgress,
    );
  }
}
