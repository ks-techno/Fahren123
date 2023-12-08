import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:dio/dio.dart' as ApiClient;
import 'package:get/get.dart';

class ApiChecker {
  static void checkUnAuthorization(ApiClient.Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSplashRoute());
    }
  }
}
