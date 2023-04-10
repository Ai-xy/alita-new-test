import 'package:flutter/material.dart';

import 'app_env.dart';
import 'app_language.dart';

abstract class AppConfig {
  static const String videoSuffix =
      '?x-oss-process=video/snapshot,t_1000,f_jpg,w_0,h_0,m_fast,ar_auto';
  static AppEnv env = AppEnv.dev;

  static AppLanguage appLanguage = AppLanguage.en;

  static String deviceId = '';

  static String appVersion = '1.0.0';

  static setDeviceId(String id) {
    deviceId = id;
  }

  static setAppVersion(String version) {
    appVersion = version;
  }

  static setAppLanguage(String lan) {
    for (AppLanguage item in AppLanguage.values) {
      if (lan == item.name) {
        appLanguage = item;
      }
    }
  }

  static setAppLocale(Locale locale) {
    for (AppLanguage item in AppLanguage.values) {
      if (locale.languageCode == item.locale.languageCode) {
        appLanguage = item;
      }
    }
  }
}
