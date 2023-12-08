import 'dart:async';
import 'package:Fahren123/data/api/Api_Handler/api_error_response.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:Fahren123/enums/otp_verify_type.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:Fahren123/view/screens/forget/create_or_change_pass_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import '../data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {

  final AuthRepo authRepo;
  AuthController({required this.authRepo}) {
   // _notification = authRepo.isNotificationActive();
  }

  int ?forgotUserId;
  String ?forgotUserEmail;

  UserInfoModel ?getLoginUserData(){
    return authRepo.getLoginUserData();
  }
  void updateLoginUserData({required UserInfoModel user}){
    authRepo.saveLoginUserData(user: user);
  }


  bool clearSharedData() {
    authRepo.clearSharedData();
    return true;
  }

  bool _notification = true;
  bool _acceptTerms = true;

  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;

  // Future<ResponseModel> registration(SignUpBody signUpBody) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.registration(signUpBody);
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     if(!Get.find<SplashController>().configModel.customerVerification) {
  //       authRepo.saveUserToken(response.body["token"]);
  //       await authRepo.updateToken();
  //     }
  //     responseModel = ResponseModel(true, response.body["token"]);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  Future<Map<String,dynamic>> login(String email, String password,String fcm, BuildContext context) async {
    Map<String,dynamic> response = await authRepo.login( password: password, email: email, fcm:fcm, isWantSuccessMessage: true);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
      UserInfoModel user = UserInfoModel.fromJson(result['result']);
    



      if( result['result']['password_changed'] == '0'){
        //iska matlab hum isse reset password wale page per bhej dete hai
        // Get.find<AuthController>().logout(result['result']['id']);

 authRepo.saveLoginUserData(user: user,password: password);

        // Get.toNamed(RouteHelper.getChangePasswordRoute(isChangePassword: false, email: user.email));
      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrChangePasswordScreen(comingFrom: 'login', email: email,isChangePassword: true,)));



      }else if(result['result']['is_login'] == '1'){
        //iska matlab kisi or device per logged in hai
        //just for test
        // Get.find<AuthController>().logout(result['result']['id']);

         showCustomSnackBar(
        "You are logged in on another device",
        isError: true,
      );
      } else{
          showCustomSnackBar(
        "Successfully Login",
        isError: false,
      );
 authRepo.saveLoginUserData(user: user,password: password);
      if(user.translationLanguage!=null){
     
          Get.offAllNamed(RouteHelper.getMainScreenRoute());
       
      }else{
        Get.offAllNamed(RouteHelper.getSelectLanguageRoute(isFromLogin: true));
      }
      }



     
    }
    return response;
  }
   Future refreshLogin(String fcm) async {
    UserInfoModel ?user =  getLoginUserData();
    String ?userPassword =  authRepo.getUserPassword();
    if(user!=null && userPassword!=null){
      debugPrint("user.:-> ${user.toJson()}");
      Map<String,dynamic> response = await authRepo.login(email: user.email,fcm:fcm, password: userPassword,isShowLoading:false, isWantSuccessMessage: false);
      if(response.containsKey(API_RESPONSE.SUCCESS)){
        Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
        UserInfoModel user = UserInfoModel.fromJson(result['result']);
        authRepo.saveLoginUserData(user: user, password: userPassword);
        print("user.translationLanguage:-> ${user.translationLanguage}");
        if(user.translationLanguage!=null){
          if(user.paymentStatus=="1"){
            Get.offAllNamed(RouteHelper.getMainScreenRoute());
          }else{
            /// Go to questions page with trial questions
            Get.offAllNamed(RouteHelper.getTrialQuestionScreenRoute());
          }
        }else{
          Get.toNamed(RouteHelper.getSelectLanguageRoute());
        }
      }
      return response;
    }
  }
  Future<bool> verifyOtp(int otpCode,OtpVerifyType verifyType,int userId) async {
    bool isVerified = false;
    Map<String,dynamic> response = await authRepo.verifyOtp(otpCode: otpCode, verifyType: verifyType,userId: userId);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      isVerified = true;
      forgotUserId = null;
      if(verifyType==OtpVerifyType.RegisterVerify){
        // UserInfoModel ?userInfoModel= getLoginUserData();
        // userInfoModel?.isVerified = true;
        // if(userInfoModel!=null){
        //   updateLoginUserData(user: userInfoModel);
        // }
        Get.offAllNamed(RouteHelper.getSignInRoute());
        // Get.offAllNamed(RouteHelper.getMainScreenRoute());
      }else{
        Get.offNamed(RouteHelper.getChangePasswordRoute(isChangePassword: false, email: ''));
      }
    }
    return isVerified;
  }
  Future<bool> forgetVerifyOtp(int otpCode,OtpVerifyType verifyType,String email) async {
    bool isVerified = false;
    Map<String,dynamic> response = await authRepo.forgetVerifyOtp(otpCode: otpCode, verifyType: verifyType,email: email);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      isVerified = true;
      forgotUserId = null;
      if(verifyType==OtpVerifyType.RegisterVerify){
        // UserInfoModel ?userInfoModel= getLoginUserData();
        // userInfoModel?.isVerified = true;
        // if(userInfoModel!=null){
        //   updateLoginUserData(user: userInfoModel);
        // }
        Get.offAllNamed(RouteHelper.getSignInRoute());
        // Get.offAllNamed(RouteHelper.getMainScreenRoute());
      }else{
        Get.offNamed(RouteHelper.getChangePasswordRoute(isChangePassword: false, email: ''));
      }
    }
    return isVerified;
  }

  Future<Map<String,dynamic>> signUp({
      required String email,
      required String name,
      required String password,
      required String gender,
      required String phoneNumber,
    }) async {
    Map<String,dynamic> response = await authRepo.signUp(
      email: email,
      password: password,
      name:name,
      phoneNumber: phoneNumber,
      gender: gender,
    );
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
      int userId = result['result']['user_id'];
      // authRepo.saveLoginUserData(user: UserInfoModel.fromJson(result['result']));
      // Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.RegisterVerify, userId: userId));
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }
    return response;
  }

  Future<Map<String,dynamic>> forgetPassword(String email) async {
    forgotUserEmail = null;
    forgotUserId = null;
    Map<String,dynamic> response = await authRepo.forgetPassword(email: email,);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      forgotUserEmail = response[API_RESPONSE.SUCCESS]['result']['email'];
      forgotUserId = response[API_RESPONSE.SUCCESS]['result']['id'];
      Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.ForgetPassword, userId: null));
    }
    return response;
  }

  Future<Map<String,dynamic>> resetPassword(String password) async {
    Map<String,dynamic> response = await authRepo.resetPassword(email: forgotUserEmail??"",password: password);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }
    return response;
  }

  Future<Map<String,dynamic>> changePassword(String user_id, String oldPassword, String password,) async {
    Map<String,dynamic> response = await authRepo.changePassword(user_id: user_id,  password: password, oldPassword:oldPassword);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Get.offAllNamed(RouteHelper.getMainScreenRoute());
    }
    return response;
  }

  Future<Map<String,dynamic>> logout(String id) async {
    Map<String,dynamic> response = await authRepo.logout(id);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      authRepo.clearSharedData();
      if(id == ''){
      Get.offAllNamed(RouteHelper.getSignInRoute());

      }
    }
    return response;
  }
  Future<Map<String,dynamic>> deleteAccount() async {
    Map<String,dynamic> response = await authRepo.deleteAccount();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      authRepo.clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }
    return response;
  }

  // Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.loginWithSocialMedia(socialLogInBody.email);
  //   if (response.statusCode == 200) {
  //     String _token = response.body['token'];
  //     if(_token != null && _token.isNotEmpty) {
  //       if(Get.find<SplashController>().configModel.customerVerification && response.body['is_phone_verified'] == 0) {
  //         Get.toNamed(RouteHelper.getVerificationRoute(socialLogInBody.email, _token, RouteHelper.signUp, ''));
  //       }else {
  //         authRepo.saveUserToken(response.body['token']);
  //         await authRepo.updateToken();
  //         Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
  //       }
  //     }else {
  //       Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
  //     }
  //   } else {
  //     showCustomSnackBar(response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  // }

  // Future<void> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.registerWithSocialMedia(socialLogInBody);
  //   if (response.statusCode == 200) {
  //     String _token = response.body['token'];
  //     if(Get.find<SplashController>().configModel.customerVerification && response.body['is_phone_verified'] == 0) {
  //       Get.toNamed(RouteHelper.getVerificationRoute(socialLogInBody.phone, _token, RouteHelper.signUp, ''));
  //     }else {
  //       authRepo.saveUserToken(response.body['token']);
  //       await authRepo.updateToken();
  //       Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
  //     }
  //   } else {
  //     showCustomSnackBar(response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  // }

  // Future<ResponseModel> forgetPassword(String email) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.forgetPassword(email);
  //
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     responseModel = ResponseModel(true, response.body["message"]);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<void> updateToken() async {
  //   await authRepo.updateToken();
  // }

  // Future<ResponseModel> verifyToken(String email) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.verifyToken(email, _verificationCode);
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     responseModel = ResponseModel(true, response.body["message"]);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<ResponseModel> resetPassword(String resetToken, String number, String password, String confirmPassword) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.resetPassword(resetToken, number, password, confirmPassword);
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     responseModel = ResponseModel(true, response.body["message"]);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<ResponseModel> checkEmail(String email) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.checkEmail(email);
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     responseModel = ResponseModel(true, response.body["token"]);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<ResponseModel> verifyEmail(String email, String token) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.verifyEmail(email, _verificationCode);
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     authRepo.saveUserToken(token);
  //     await authRepo.updateToken();
  //     responseModel = ResponseModel(true, response.body["message"]);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<ResponseModel> verifyPhone(String phone, String token) async {
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.verifyPhone(phone, _verificationCode);
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     authRepo.saveUserToken(token);
  //     await authRepo.updateToken();
  //     responseModel = ResponseModel(true, response.body["message"]);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<void> updateZone() async {
  //   Response response = await authRepo.updateZone();
  //   if (response.statusCode == 200) {
  //     // Nothing to do
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  // }

  // String _verificationCode = '';

  // String get verificationCode => _verificationCode;

  // void updateVerificationCode(String query) {
  //   _verificationCode = query;
  //   update();
  // }


  // bool _isActiveRememberMe = false;

  // bool get isActiveRememberMe => _isActiveRememberMe;

  // void toggleTerms() {
  //   _acceptTerms = !_acceptTerms;
  //   update();
  // }

  // void toggleRememberMe() {
  //   _isActiveRememberMe = !_isActiveRememberMe;
  //   update();
  // }

  // bool isLoggedIn() {
  //   return authRepo.isLoggedIn();
  // }

  // bool clearSharedData() {
  //   Get.find<SplashController>().setModule(null);
  //   return authRepo.clearSharedData();
  // }

  // void saveUserNumberAndPassword(String number, String password, String countryCode) {
  //   authRepo.saveUserNumberAndPassword(number, password, countryCode);
  // }

  // String getUserNumber() {
  //   return authRepo.getUserNumber() ?? "";
  // }

  // String getUserCountryCode() {
  //   return authRepo.getUserCountryCode() ?? "";
  // }

  // String getUserPassword() {
  //   return authRepo.getUserPassword() ?? "";
  // }

  // Future<bool> clearUserNumberAndPassword() async {
  //   return authRepo.clearUserNumberAndPassword();
  // }

  // String getUserToken() {
  //   return authRepo.getUserToken();
  // }

  // bool setNotificationActive(bool isActive) {
  //   _notification = isActive;
  //   authRepo.setNotificationActive(isActive);
  //   update();
  //   return _notification;
  // }

}