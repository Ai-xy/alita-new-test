import 'package:alita/R/app_theme.dart';
import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/initializer_manager.dart';
import 'package:alita/pages/home/home_binding.dart';
import 'package:alita/router/app_path.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'router/app_router.dart';
import 'translation/app_translation.dart';

void main() {
  InitializerManager.initialize(AppEnv.dev).whenComplete(() async {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        splitScreenMode: true,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (BuildContext context, Widget? child) {
          return PiPMaterialApp(
            pipParams: PiPParams(
              pipWindowWidth: 144.w,
              pipWindowHeight: 180.h,
              bottomSpace: 108.h,
              rightSpace: 16.w,
            ),
            builder: (BuildContext context, Widget? child) {
              return GetMaterialApp(
                navigatorKey: Get.key,
                locale: const Locale('en', 'US'),
                theme: AppTheme.lightTheme,
                initialBinding: HomeBinding(),
                initialRoute: AppPath.home,
                getPages: AppRouter.pages,
                translations: AppTranslations(),
                supportedLocales: const [
                  Locale('en', 'US'),
                ],
                // localizationsDelegates: [
                //   MaterialLocalizations
                // ],
                // fallbackLocale: const Locale('en', 'US'),
                builder: (context, child) {
                  return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: BotToastInit()(
                          context, child ?? const SizedBox.shrink()));
                },
                navigatorObservers: [
                  BotToastNavigatorObserver(),
                ],
              );
            },
          );
        });
  }
}
