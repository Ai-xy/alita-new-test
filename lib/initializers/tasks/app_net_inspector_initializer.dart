import 'package:alita/config/app_env.dart';
import 'package:alita/event_bus/event_bus.dart';
import 'package:alita/event_bus/events/app_connectivity_changed_event.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppNetInspectorInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return Connectivity().checkConnectivity().then((v) {
      eventBus.fire(AppConnectityChangedEvent(connectivityResult: v));
    }).whenComplete(() {
      Connectivity().onConnectivityChanged.listen((event) {
        eventBus.fire(AppConnectityChangedEvent(connectivityResult: event));
      });
    });
  }
}
