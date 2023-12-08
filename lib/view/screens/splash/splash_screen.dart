import 'dart:async';
import 'package:Fahren123/controller/app_settings_controller.dart';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:Fahren123/data/repository/auth_repo.dart';
import 'package:Fahren123/util/app_strings.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/util/images.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/splash_controller.dart';
import '../../../helper/route_helper.dart';
import '../../base/no_internet_screen.dart';


class SplashScreen extends StatefulWidget {
  final String ?orderID;
  const SplashScreen({Key? key, this.orderID}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
   final FirebaseMessaging _fcm = FirebaseMessaging.instance;


  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? AppString.noConnection .tr : AppString.connected.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    // Get.find<CartController>().getCartData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() async{
    await Get.find<AppSettingsController>().fetchAppSettings();
   String? fcmToken = await _fcm.getToken();

    await Get.find<AuthController>().refreshLogin(fcmToken!);
    UserInfoModel ?user = Get.find<AuthController>().getLoginUserData();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dynamic? selected_lang = AuthRepo(sharedPreferences: sharedPreferences).getSelectedLanguage();

    
    //ye tha purana flow
    // if(user!= null){
    //   await Future.delayed(const Duration(seconds: 1));
    //   if(user.translationLanguage!=null){
    //     Get.offNamed(RouteHelper.getMainScreenRoute());
    //   }else{
    //     Get.offNamed(RouteHelper.getSignInRoute());
    //     Get.toNamed(RouteHelper.getSelectLanguageRoute(isFromLogin: true));
    //   }
    // }else{
    //   Future.delayed(const Duration(seconds: 1)).then((value){
    //     // Get.offNamed(RouteHelper.getSignInRoute());
    //     Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
    //       transitionDuration: Duration(milliseconds: 800),
    //       reverseTransitionDuration: Duration(milliseconds: 800),
    //       pageBuilder: (context, a,b) => SignInScreen() ), (route) => false);
    //   });
    // }

    //ye hai new flow

    if(user == null){
      //matlb login nahi hua
      //ya to language wala ya trial question wala page

      debugPrint("selected_lang");
      debugPrint(selected_lang.toString());

      if(selected_lang == null){
      Get.toNamed(RouteHelper.getSelectLanguageRoute(isFromLogin: true));

      }else{
        Get.offNamed(RouteHelper.getMainScreenRoute());
      }
    }else{
      //matlb lagged in hai, ab payment ka scene dekhna hai to buss main screen ki trf bhej deina hai
Get.offNamed(RouteHelper.getMainScreenRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.find<SplashController>().initSharedData();

    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return SizedBox(
          height: context.height,
          width: context.width,
          // decoration: BoxDecoration(
          //   gradient: AppColor.drawerGradient,
          // ),
          child: Center(
            child: splashController.hasConnection ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Images.logo, width: 200),
                /*SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),*/
              ],
            ) : NoInternetScreen(child: SplashScreen(orderID: widget.orderID)),
          ),
        );
      }),
    );
  }
}
