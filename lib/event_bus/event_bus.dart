import 'package:rxdart/subjects.dart';

class _EventBus {
  final BehaviorSubject _behaviorSubject = BehaviorSubject();

  Stream<T> on<T>() {
    if (T == dynamic) {
      return _behaviorSubject.stream as Stream<T>;
    } else {
      return _behaviorSubject.stream.where((event) => event is T).cast<T>();
    }
  }

  void fire(event) {
    _behaviorSubject.add(event);
  }

  void destroy() {
    _behaviorSubject.close();
  }
}

final eventBus = _EventBus();
