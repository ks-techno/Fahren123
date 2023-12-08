import 'dart:io';

import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/api/Api_Handler/api_call_Structure.dart';
import 'package:Fahren123/data/api/Api_Handler/api_constants.dart';
import 'package:dio/dio.dart' as ApiClient;
import 'package:get/get.dart';
import '../../util/app_constants.dart';

class AppSettingsRepo {
  AppSettingsRepo();
  Future<Map<String, dynamic>> getAppSettings() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.APP_SETTINGS,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> purchasePlanViaBankTransfer({required String transactionId, required String amount, required String imagePath}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.BANK_TRANSFER,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      body: ApiClient.FormData.fromMap({
        "payment_id": transactionId,
        "amount": amount,
        "user_id": Get.find<AuthController>().getLoginUserData()!.id,
        "payment_image": await ApiClient.MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last)
      }),
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }
}
