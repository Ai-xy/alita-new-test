import 'package:date_format/date_format.dart';
import 'package:dart_date/dart_date.dart';

String formatTime(DateTime date) {
  DateTime now = DateTime.now();
  String date1 = formatDate(date, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  String date2 = formatDate(now, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  return date1 == date2 ? formatDate(date, [HH, ':', nn]) : date1;
}

String formatMillseconds(int millSeconds, {List<String>? formats}) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millSeconds);
  return formdatDateTime(date);
}

String formdatDateTime(DateTime date) {
  DateTime now = DateTime.now();
  if (now.isSameDay(date)) {
    return formatDate(date, [HH, ':', nn]);
  }
  if (now.isSameYear(date)) {
    return formatDate(date, [mm, '/', dd, HH, ':', nn]);
  }
  return formatDate(date, [yyyy, '/', mm, '/', dd, ' ', HH, ':', nn]);
}

String formatTimeMMSS(int millseconds) {
  int seconds = (millseconds / 1000).ceil();
  String mm = (seconds / 60).truncate().toString().padLeft(2, '0');
  String ss = (seconds % 60).toString().padLeft(2, '0');
  return '$mm:$ss';
}
