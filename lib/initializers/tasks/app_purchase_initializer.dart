import 'package:alita/config/app_env.dart';
import 'package:alita/event_bus/event_bus.dart';
import 'package:alita/event_bus/events/app_purchase_event.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:alita/util/log.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class AppPurchaseInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return InAppPurchase.instance.isAvailable().then((value) {
      if (value) {
        return InAppPurchase.instance.purchaseStream.listen((event) {
          eventBus.fire(AppPurchaseEvent(purchaseDetailsList: event));
        }, onError: (err, s) {
          Log.e('内购状态订阅出错', error: err, stackTrace: s, tag: 'InAppPurchase');
        });
      }
      Log.i('内购服务不可用', tag: 'InAppPurchase');
    }).catchError((err, s) {
      Log.e('内购可用状态查询出错', error: err, stackTrace: s, tag: 'InAppPurchase');
    });
  }
}
