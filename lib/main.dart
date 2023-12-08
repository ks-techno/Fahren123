import 'dart:async';
import 'dart:io';
import 'package:Fahren123/helper/firebaseInit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'controller/splash_controller.dart';
import 'controller/theme_controller.dart';
import 'helper/get_di.dart' as di;
import 'helper/responsive_helper.dart';
import 'helper/route_helper.dart';
import 'util/app_constants.dart';
import 'util/messages.dart';

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.landscapeRight
  ]);

  // if (Platform.isAndroid) {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Map<String, Map<String, String>> languages;
  // const MyApp({Key? key, required this.languages,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseInit.init();
    // if (GetPlatform.isWeb) {
    //   Get.find<SplashController>().initSharedData();
    //   Get.find<CartController>().getCartData();
    //   _route();
    // }

    return GetBuilder<ThemeController>(builder: (themeController) {
      // return GetBuilder<LocalizationController>(builder: (localizeController) {
      return GetBuilder<SplashController>(builder: (splashController) {
        return (GetPlatform.isWeb)
            ? const SizedBox()
            : GetMaterialApp(
                title: AppConstants.APP_NAME,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [BotToastNavigatorObserver()],
                builder: (BuildContext context, Widget? child) {
                  child = BotToastInit()(context, child);
                  child = MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: child,
                  );
                  return child;
                },
                navigatorKey: Get.key,
                theme: themeController.getTheme,
                // locale: localizeController.locale,
                // translations: Messages(languages: languages),
                // fallbackLocale: Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode),
                initialRoute: GetPlatform.isWeb
                    ? RouteHelper.getInitialRoute()
                    : RouteHelper.getSplashRoute(),
                getPages: RouteHelper.routes,
                defaultTransition: Transition.rightToLeft,
                transitionDuration: const Duration(milliseconds: 300),
              );
      });
      // });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
