import 'dart:convert';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/api/Api_Handler/api_call_Structure.dart';
import 'package:Fahren123/data/api/Api_Handler/api_constants.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../enums/otp_verify_type.dart';
import '../../util/app_constants.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.sharedPreferences});

  String? getAuthToken() {
    UserInfoModel ?userInfo = getLoginUserData();
    return userInfo?.accessToken;
  }
  String? getAuthTokenType() {
    UserInfoModel ?userInfo = getLoginUserData();
    return userInfo?.tokenType;
  }

  dynamic ?getSelectedLanguage(){
    dynamic ?lang ;

    try{

      lang = jsonDecode(sharedPreferences.getString('selectedLanguage')!);

    }catch(e){}
    return lang;
  }
  void setSelectedLanguage(dynamic lang){
    sharedPreferences.setString('selectedLanguage',jsonEncode(lang));
    
  }

  void saveLoginUserData({required UserInfoModel user, String ?password}){
    if(password!=null){
      sharedPreferences.setString(AppConstants.LOGIN_USER_PASSWORD, password);
    }
    sharedPreferences.setString(AppConstants.LOGIN_USER, json.encode(user.toJson()));
  }
  UserInfoModel ?getLoginUserData(){
    String ?userData =  sharedPreferences.getString(AppConstants.LOGIN_USER,);
    return userData!=null? UserInfoModel.fromJson(json.decode(userData)): null;
  }

  String ?getUserPassword(){
    return sharedPreferences.getString(AppConstants.LOGIN_USER_PASSWORD,);
  }

   Future<Map<String, dynamic>> login({required String email,required String password,required String fcm, bool isShowLoading=true, bool isWantSuccessMessage = true }) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.LOGIN,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: isWantSuccessMessage,
      body: ApiClient.FormData.fromMap({
        "email": email,
        "password": password,
        "fcm_token":fcm
      }),
    );
    return await apiObject.requestAPI(isShowLoading: isShowLoading,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> verifyOtp({required int otpCode, required OtpVerifyType verifyType, required int userId}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: verifyType==OtpVerifyType.RegisterVerify? "${AppConstants.REGISTER_OTP_VERIFY}user_id=$userId&otp=$otpCode": AppConstants.OTP_VERIFy,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: true,
      // body: ApiClient.FormData.fromMap({
      //   "user_id": userId,
      //   "code": otpCode,
      // }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> forgetVerifyOtp({required int otpCode, required OtpVerifyType verifyType, required String email}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.forget_OTP_VERIFY}email=$email&otp=$otpCode",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: true,
      // body: ApiClient.FormData.fromMap({
      //   "user_id": userId,
      //   "code": otpCode,
      // }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String name,
    required String password,
    required String gender,
    required String phoneNumber,

  }) async {
    Map<String,dynamic> signupBody = {
      "name":name,
      "email": email,
      "password": password,
      "gender": gender,
      "phone": phoneNumber,
    };
    debugPrint("signupBody:-> $signupBody");
    debugPrint("AppConstants.SIGNUP:-> ${AppConstants.BASE_URL+AppConstants.SIGNUP}");
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.SIGNUP,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap(signupBody),
    );

    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> changePassword({required String user_id, required String oldPassword,required String password}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.CHANGE2,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "user_id":user_id,
        "password":oldPassword,
        "new_password": password,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> forgetPassword( {required String email,}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.FORGET,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "email": email,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> getUserById( {required String id,required bool loader}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.GETBYID+id,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
     
    );
    return await apiObject.requestAPI(isShowLoading: loader,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> resetPassword( {required String email, required String password,}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.RESET,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "email": email,
        'password': password
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> logout(String id) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.LOGOUT}${id== ''? Get.find<AuthController>().getLoginUserData()!.id: id}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: id == ''? true:false,
      
      // body: ApiClient.FormData.fromMap({
      //   "token_value": email,
      // }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> deleteAccount() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.DELETE_ACCOUNT}${Get.find<AuthController>().getLoginUserData()!.id}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: true,
      // body: ApiClient.FormData.fromMap({
      //   "token_value": email,
      // }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }


  // Future<Response> updateFcmToken() async {
  //   String _deviceToken;
  //   if (GetPlatform.isIOS && !GetPlatform.isWeb) {
  //     FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  //     NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  //       alert: true, announcement: false, badge: true, carPlay: false,
  //       criticalAlert: false, provisional: false, sound: true,
  //     );
  //     if(settings.authorizationStatus == AuthorizationStatus.authorized) {
  //       _deviceToken = await _saveDeviceToken();
  //     }
  //   }else {
  //     _deviceToken = await _saveDeviceToken();
  //   }
  //   if(!GetPlatform.isWeb) {
  //     FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
  //   }
  //   return await apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": _deviceToken});
  // }
  //
  // Future<String> _saveDeviceFcmToken() async {
  //   String _deviceToken = '@';
  //   if(!GetPlatform.isWeb) {
  //     try {
  //       _deviceToken = await FirebaseMessaging.instance.getToken();
  //     }catch(e) {}
  //   }
  //   if (_deviceToken != null) {
  //     print('--------Device Token---------- '+_deviceToken);
  //   }
  //   return _deviceToken;
  // }

  // Future<Response> forgetPassword(String phone) async {
  //   return await apiClient.postData(AppConstants.FORGET_PASSWORD_URI, {"phone": phone});
  // }

  // Future<Response> verifyToken(String phone, String token) async {
  //   return await apiClient.postData(AppConstants.VERIFY_TOKEN_URI, {"phone": phone, "reset_token": token});
  // }

  // Future<Response> resetPassword(String resetToken, String number, String password, String confirmPassword) async {
  //   return await apiClient.postData(
  //     AppConstants.RESET_PASSWORD_URI,
  //     {"_method": "put", "reset_token": resetToken, "phone": number, "password": password, "confirm_password": confirmPassword},
  //   );
  // }

  // Future<Response> checkEmail(String email) async {
  //   return await apiClient.postData(AppConstants.CHECK_EMAIL_URI, {"email": email});
  // }

  // Future<Response> verifyEmail(String email, String token) async {
  //   return await apiClient.postData(AppConstants.VERIFY_EMAIL_URI, {"email": email, "token": token});
  // }

  // Future<bool> saveUserToken(String token) async {
  //   apiClient.token = token;
  //   apiClient.updateHeader(
  //     token, null, sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
  //     Get.find<SplashController>().module != null ? Get.find<SplashController>().module.id : null,
  //   );
  //   return await sharedPreferences.setString(AppConstants.TOKEN, token);
  // }


  bool isLoggedIn() {
    return getLoginUserData()!=null;
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.LOGIN_USER);
    sharedPreferences.remove(AppConstants.LOGIN_USER_PASSWORD);
    sharedPreferences.clear();
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }


  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  // void setNotificationActive(bool isActive) {
  //   // if(isActive) {
  //   //   updateToken();
  //   // }else {
  //     if(!GetPlatform.isWeb) {
  //       FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
  //       if(isLoggedIn()) {
  //         FirebaseMessaging.instance.unsubscribeFromTopic('zone_${Get.find<LocationController>().getUserAddress().zoneId}_customer');
  //       }
  //     }
  //   }
  //   sharedPreferences.setBool(AppConstants.NOTIFICATION, isActive);

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }
}
