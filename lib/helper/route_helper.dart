import 'dart:convert';
import 'package:Fahren123/data/model/response/app_settings_model.dart';
import 'package:Fahren123/data/model/response/category_model.dart';
import 'package:Fahren123/data/model/response/question_model.dart';
import 'package:Fahren123/view/base/CustomImagePicker/camera.dart';
import 'package:Fahren123/view/screens/language/select_language_screen.dart';
import 'package:Fahren123/view/screens/question/payment_screen.dart';
import 'package:Fahren123/view/screens/question/question_screen.dart';
import 'package:Fahren123/view/screens/question/trial_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Fahren123/view/screens/auth/sign_in_screen.dart';
import 'package:Fahren123/view/screens/auth/sign_up_screen.dart';
import 'package:Fahren123/view/screens/forget/create_or_change_pass_screen.dart';
import 'package:Fahren123/view/screens/forget/forget_pass_screen.dart';
import 'package:Fahren123/view/screens/forget/verification_screen.dart';
import 'package:Fahren123/view/screens/home/main_screen.dart';
import 'package:Fahren123/view/screens/privacy%20policy/privacy_policy_screen.dart';
import 'package:Fahren123/view/screens/splash/splash_screen.dart';
import '../controller/app_settings_controller.dart';
import '../enums/otp_verify_type.dart';
import '../view/screens/question/digital_payment_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String onBoarding = '/on-boarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String otpVerification = '/verification';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  static const String interest = '/interest';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/reset-password';
  static const String privacyPolicy = '/privacyPolicy';
  static const String selectLanguage = '/selectLanguage';
  static const String solarController = '/solarController';
  static const String solarDetails = '/solarDetails';
  static const String addSolar = '/addSolar';
  static const String search = '/search';
  static const String store = '/store';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String coupon = '/coupon';
  static const String notification = '/notification';
  static const String map = '/map';
  static const String address = '/address';
  static const String orderSuccess = '/order-successful';
  static const String payment = '/payment';
  static const String checkout = '/checkout';
  static const String orderTracking = '/track-order';
  static const String basicCampaign = '/basic-campaign';
  static const String html = '/html';
  static const String categories = '/categories';
  static const String categoryItem = '/category-item';
  static const String popularItems = '/popular-items';
  static const String itemCampaign = '/item-campaign';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String storeReview = '/store-review';
  static const String allStores = '/stores';
  static const String itemImages = '/item-images';
  static const String parcelCategory = '/parcel-category';
  static const String parcelLocation = '/parcel-location';
  static const String parcelRequest = '/parcel-request';
  static const String searchStoreItem = '/search-store-item';
  static const String order = '/order';
  static const String itemDetails = '/item-details';
  static const String question = '/question';
  static const String trialQuestion = '/trial-question';
  static const String purchasePlan = '/purchasePlan';
  static const String customImagePicker = '/pickImage';
  static const String digitalPayment = '/digitalPayment';

  static String getInitialRoute() => initial;
  static String getSplashRoute({int ?orderID}) => '$splash${orderID!=null?"?id=$orderID":""}';
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getOnBoardingRoute() => onBoarding;
  static String getSignInRoute() => signIn;
  static String getChangePasswordRoute({required bool isChangePassword, required String email}) => "$changePassword?isChangePassword=${isChangePassword?1:0}";
  static String getSignUpRoute() => signUp;
  static String getPrivacyPolicyRoute() => privacyPolicy;
  static String getSelectLanguageRoute({bool isFromLogin=false}) => "$selectLanguage?isFromLogin=${isFromLogin?"1":"0"}";
  static String getSolarControllerRoute() => solarController;
  static String getAddSolarRoute() => addSolar;
  static String getMainScreenRoute() => main;
  static String getForgetPasswordRoute() => forgotPassword;
  static String getQuestionScreenRoute({required QuestionCategory questionCategory}) => "$question?questionCategory=${jsonEncode(questionCategory.toJson())}";
  static String getTrialQuestionScreenRoute() => trialQuestion;
  static String getPurchasePlanScreenRoute() => purchasePlan;
  static String getOtpVerificationRoute({required OtpVerifyType verificationType,  int ?userId,  bool ?isChangePassword}) => "$otpVerification?verificationType=${verificationType.name}${userId!=null? '&user_id=$userId':''}";
  static String getCustomImagePickerRoute() => customImagePicker;
  static String getDigitalPaymentRoute({required PaymentMethod paymentMethod}) => "$digitalPayment?digitalPayment=${jsonEncode(paymentMethod.toJson())}";

  static List<GetPage> routes = [

    GetPage(name: splash, page: () => SplashScreen(orderID:  Get.parameters['id'])),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: privacyPolicy, page: () =>  PrivacyPolicyScreen()),
    GetPage(name: selectLanguage, page: (){
      int  fromLogin = int.tryParse(Get.parameters['isFromLogin']??"0")??0;
      return SelectLanguageScreen(isFromLogin: fromLogin==1,);
    }),
    GetPage(name: question, page: () {
      String questionCategory = Get.parameters['questionCategory']!;
      return QuestionScreen(questionCategory: QuestionCategory.fromJson(jsonDecode(questionCategory)));
    }),
    GetPage(name: trialQuestion, page: () => const TrialQuestionScreen()),
    GetPage(name: purchasePlan, page: () => const PaymentScreen()),
    GetPage(name: changePassword, page: () => CreateOrChangePasswordScreen( comingFrom: '', isChangePassword: Get.parameters['isChangePassword']=='1', email: '' ,)),
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),
    GetPage(
        name: otpVerification,
        page: ()
        {
          debugPrint("Get.parameters:-> ${Get.parameters}");
          OtpVerifyType verifyType = OtpVerifyType.RegisterVerify;
          int ?userId = int.tryParse(Get.parameters['user_id']??'');
          if(Get.parameters['verificationType']==OtpVerifyType.ForgetPassword.name){
            verifyType = OtpVerifyType.ForgetPassword;
          }else if(Get.parameters['verificationType']==OtpVerifyType.ChangePassword.name){
            verifyType = OtpVerifyType.ChangePassword;
          }else{
            verifyType = OtpVerifyType.RegisterVerify;
          }
          return OtpVerificationScreen(
            verifyType: verifyType,
            userId: userId
          );
        }),
    GetPage(name: customImagePicker, page: () => const CustomImagePickerScreen()),
    GetPage(name: digitalPayment, page: (){
      Map<String,dynamic> payment  = jsonDecode(Get.parameters['digitalPayment']!);
      PaymentMethod digitalPayment = PaymentMethod.fromLocalJson(payment);
      return DigitalPaymentGatewayScreen(digitalPayment: digitalPayment,);
    }),

    // GetPage(name: verification, page: () {
    //   List<int> _decode = base64Decode(Get.parameters['pass'].replaceAll(' ', '+'));
    //   String _data = utf8.decode(_decode);
    //   return VerificationScreen(
    //     number: Get.parameters['number'], fromSignUp: Get.parameters['page'] == signUp, token: Get.parameters['token'],
    //     password: _data,
    //   );
    // }),

    // GetPage(name: orderSuccess, page: () => getRoute(OrderSuccessfulScreen(
    //   orderID: Get.parameters['id'], success: Get.parameters['status'].contains('success'),
    //   parcel: Get.parameters['type'] == 'parcel',
    // ))),

  ];

  static getRoute(Widget navigateTo) {
    int _minimumVersion = 0;
    if(GetPlatform.isAndroid) {
      _minimumVersion = 1; //Get.find<SplashController>().configModel.appMinimumVersionAndroid;
    }else if(GetPlatform.isIOS) {
      _minimumVersion = 1; //Get.find<SplashController>().configModel.appMinimumVersionIos;
    }
    return
      // AppConstants.APP_VERSION < _minimumVersion
      //   ? UpdateScreen(isUpdate: true)
      //   : Get.find<SplashController>().configModel.maintenanceMode ? UpdateScreen(isUpdate: false)
      //   : Get.find<LocationController>().getUserAddress() == null
      //   ? AccessLocationScreen(fromSignUp: false, fromHome: false, route: Get.currentRoute)
      //   :
    navigateTo;
  }
}