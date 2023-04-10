bool isEmpty(Object? object, {bool autoTrim = true}) {
  if (object is Iterable) {
    return object.isEmpty;
  }
  if (object is String) {
    String text = autoTrim ? object.trim() : object;
    return text.isEmpty;
  }
  return object == null;
}
