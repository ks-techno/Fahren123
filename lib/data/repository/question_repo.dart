import 'dart:convert';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/api/Api_Handler/api_call_Structure.dart';
import 'package:Fahren123/data/api/Api_Handler/api_constants.dart';
import 'package:Fahren123/data/model/response/category_model.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../enums/otp_verify_type.dart';
import '../../util/app_constants.dart';

class QuestionRepo {
  QuestionRepo();
  Future<Map<String, dynamic>> getQuestion({required QuestionCategory questionCategory}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      // apiUrl: "${AppConstants.GET_QUESTIONS}${questionCategory.id}",
      apiUrl: "${AppConstants.GET_QUESTIONS}${questionCategory.id}&language=${Get.find<AuthController>().authRepo.getLoginUserData()!.translationLanguage!.languageName.toLowerCase()}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> getTestQuestion({required String testNumber}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      // apiUrl: "${AppConstants.GET_QUESTIONS}${questionCategory.id}",

      apiUrl: testNumber == '1'? "${AppConstants.GET_TEST1_QUESTIONS}&language=${Get.find<AuthController>().authRepo.getLoginUserData()!.translationLanguage!.languageName.toLowerCase()}" : "${AppConstants.GET_TEST2_QUESTIONS}&language=${Get.find<AuthController>().authRepo.getLoginUserData()!.translationLanguage!.languageName.toLowerCase()}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> getTrialQuestion() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      // apiUrl: "${AppConstants.GET_QUESTIONS}${questionCategory.id}",
      apiUrl:   "${AppConstants.GET_TRIAL_QUESTIONS}${Get.find<AuthController>().getLoginUserData() != null? Get.find<AuthController>().getLoginUserData()!.translationLanguage!.languageName.toLowerCase() :Get.find<AuthController>().authRepo.getSelectedLanguage()['language'].toString().toLowerCase()}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

   Future<Map<String, dynamic>> checkReferral(data) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
    

      apiUrl: "${AppConstants.CHECK_REFERRAL}",
      apiRequestMethod: API_REQUEST_METHOD.POST,
      body: ApiClient.FormData.fromMap(data),
      isWantSuccessMessage: false,

    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

   Future<Map<String, dynamic>> getPaymentPlan() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      // apiUrl: "${AppConstants.GET_QUESTIONS}${questionCategory.id}",

      apiUrl:  "${AppConstants.GET_PAYMENT_PLAN}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
    Future<Map<String, dynamic>> savePaymentPlan(String planId) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      // apiUrl: "${AppConstants.GET_QUESTIONS}${questionCategory.id}",

      apiUrl:  "${AppConstants.SAVE_PAYMENT_PLAN}paymentPlan_id=$planId&user_id=${Get.find<AuthController>().authRepo.getLoginUserData()!.id}",
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

    Future<Map<String, dynamic>> stripePayment(String transectionId,String amount) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      // apiUrl: "${AppConstants.GET_QUESTIONS}${questionCategory.id}",
      

      apiUrl:  "${AppConstants.STRIPE_PAYMENT}payment_id=$transectionId&user_id=${Get.find<AuthController>().authRepo.getLoginUserData()!.id}&payer_id=${Get.find<AuthController>().authRepo.getLoginUserData()!.id}&payer_email=${Get.find<AuthController>().authRepo.getLoginUserData()!.email}&amount=$amount&state=approved",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

     Future<Map<String, dynamic>> readNotification(String notiId) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
    

      apiUrl: "${AppConstants.READ_NOTIFICATION}&user_id=${Get.find<AuthController>().authRepo.getLoginUserData()!.id}&notificationID=$notiId",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

   Future<Map<String, dynamic>> getPerformance() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
    

      apiUrl: "${AppConstants.GET_PERFORMANCE}&user_id=${Get.find<AuthController>().authRepo.getLoginUserData()!.id}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

    Future<Map<String, dynamic>> getNotification() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
    

      apiUrl: "${AppConstants.GET_NOTIFICATION}&user_id=${Get.find<AuthController>().authRepo.getLoginUserData()!.id}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

      Future<Map<String, dynamic>> savePerformance(data) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
    

      apiUrl: "${AppConstants.SAVE_PERFORMANCE}",
      apiRequestMethod: API_REQUEST_METHOD.POST,
      body: ApiClient.FormData.fromMap(data),
      isWantSuccessMessage: false,

    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
}
