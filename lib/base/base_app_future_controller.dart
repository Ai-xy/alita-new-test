import 'dart:async';
import 'package:alita/util/log.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'base_app_controller.dart';

onJsonModelizeError(dynamic error, StackTrace stackTrace) {
  // print(stackTrace);
  Log.e("反序列化错误", error: error, stackTrace: stackTrace, tag: 'API');
  // return JsonModelizeException();
}

abstract class BaseAppFutureLoadStateController<T> extends BaseAppController
    with StateMixin<T> {
  EasyRefreshController? easyRefreshController;
  Future<T> loadData({Map? params});

  @override
  void onInit() {
    easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    fetchData();
    super.onInit();
  }

  Future<T> fetchData() {
    change(null, status: RxStatus.loading());
    return _loadData();
  }

  Future<T> _loadData() {
    return loadData().then((value) {
      Log.i('_loadData: $value');
      if (value is Iterable && value.isEmpty) {
        change(value, status: RxStatus.empty());
      } else {
        change(value, status: RxStatus.success());
      }
      return value;
    }, onError: onJsonModelizeError).catchError((err, s) {
      change(null, status: RxStatus.error());
      Log.e("API异常", error: err, stackTrace: s, tag: 'API');
      throw err;
    }).whenComplete(update);
  }

  Future retry() => fetchData();

  Future<T> onRefreshData() => _loadData();

  @override
  void onClose() {
    easyRefreshController?.dispose();
    super.onClose();
  }
}

class AppFutureBuilder<T extends BaseAppFutureLoadStateController>
    extends GetView<T> {
  final GetControllerBuilder<T> builder;
  final Object? id;
  final String? builderTag;
  final WidgetBuilder? loadingBuilder;
  final bool autoDispose;
  final bool enableRefresh;
  final String? emptyTip;
  final bool wrapWithSmartRefresher;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? errorBuilder;
  const AppFutureBuilder({
    Key? key,
    required this.builder,
    this.builderTag,
    this.id,
    this.loadingBuilder,
    this.autoDispose = true,
    this.enableRefresh = true,
    this.emptyTip,
    this.wrapWithSmartRefresher = true,
    this.emptyBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        duration: const Duration(milliseconds: 375),
        child: controller.obx(
          (state) => GetBuilder<T>(
            tag: tag,
            id: id,
            builder: builder,
            autoRemove: autoDispose,
          ),
          onEmpty: Builder(
              builder: emptyBuilder ??
                  (BuildContext context) {
                    return const Text('No data');
                  }),
          onLoading: Builder(
              builder: loadingBuilder ??
                  (BuildContext context) {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  }),
          onError: (String? s) => Builder(
              builder: errorBuilder ??
                  (BuildContext context) {
                    return const SizedBox.shrink();
                  }),
        ));
  }
}
