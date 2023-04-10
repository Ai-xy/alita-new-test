import 'package:flutter/material.dart';

enum AppLanguage {
  en(
    tag: 'en',
    locale: Locale('en', 'US'),
  ),
  zh(
    tag: 'zh',
    locale: Locale('zh', 'CH'),
  );

  final String tag;
  final Locale locale;
  const AppLanguage({required this.tag, required this.locale});
}
