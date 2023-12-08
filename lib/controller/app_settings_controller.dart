import 'dart:async';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/api/Api_Handler/api_error_response.dart';
import 'package:Fahren123/data/model/response/app_settings_model.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:Fahren123/data/repository/app_settings_repo.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom_packages/customselector/custom_message_dilog_box.dart';
import '../util/app_strings.dart';

class AppSettingsController extends GetxController implements GetxService {
  final AppSettingsRepo appSettingsRepo;
  AppSettingsController({required this.appSettingsRepo});

  AppSettings appSettings = AppSettings(paymentMethodsList: []);

  Future<Map<String,dynamic>> fetchAppSettings() async {
    Map<String,dynamic> response = await appSettingsRepo.getAppSettings();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
      appSettings = AppSettings.fromJson(result);
      
    }
    return response;
  }
  Future<Map<String,dynamic>> purchasePlanViaBankTransfer({required String transactionId, required String amount, required String imagePath,required BuildContext context}) async {
    Map<String,dynamic> response = await appSettingsRepo.purchasePlanViaBankTransfer(transactionId: transactionId, amount: amount, imagePath: imagePath);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      await messageShowDialog(descriptions: AppString.bankPaymentSuccess,);
      // showCustomSnackBar("Receipt uploaded successfully. Your plan will be upgraded after verification");
      Get.offAllNamed(RouteHelper.getMainScreenRoute());
    }
    return response;
  }

  Future<void> onPaymentSuccess() async {
    await messageShowDialog(descriptions: AppString.digitalPaymentSuccess,);
    UserInfoModel authUserData  = Get.find<AuthController>().getLoginUserData()!;
    authUserData.paymentStatus = "1";
    Get.find<AuthController>().updateLoginUserData(user: authUserData);
    Get.offAllNamed(RouteHelper.getMainScreenRoute());
  }
}