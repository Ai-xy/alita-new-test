library translation;

import 'package:get/get.dart';
part 'en_us.dart';
part 'zh_cn.dart';
part 'app_message.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS.map((key, value) => MapEntry(key.name, value)),
        'zh_CH': zhCH.map((key, value) => MapEntry(key.name, value))
      };
}
