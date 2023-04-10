import 'package:alita/event_bus/events/base/app_event.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppConnectityChangedEvent extends AppEvent {
  final ConnectivityResult connectivityResult;
  AppConnectityChangedEvent({required this.connectivityResult});
}
