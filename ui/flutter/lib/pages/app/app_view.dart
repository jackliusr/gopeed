import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../../i18n/messages.dart';
import '../../routes/router.dart';
import '../../theme/theme.dart';
import 'app_controller.dart';
import 'package:device_preview/device_preview.dart';

class AppView extends GetView<AppController> {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = controller.downloaderConfig.value;
    var dpLocale = DevicePreview.locale(context);
    if (Get.locale != dpLocale) {
      Future.delayed(
        Duration(milliseconds: 10),
        () {
          Get.updateLocale(dpLocale!);
        },
      );
    }
    return GetMaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: GopeedTheme.light,
      darkTheme: GopeedTheme.dark,
      themeMode: ThemeMode.values.byName(config.extra.themeMode),
      translations: messages,
      //locale: toLocale(config.extra.locale),
      fallbackLocale: fallbackLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: messages.keys.keys.map((e) => toLocale(e)).toList(),
      getPages: Routes.routes,
    );
  }
}
