import 'package:alita/event_bus/events/base/app_event.dart';

class AppValueChangedEvent<T> extends AppEvent {
  final T value;
  final String tag;

  AppValueChangedEvent({required this.value, required this.tag});
}
