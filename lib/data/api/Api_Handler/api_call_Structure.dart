import 'dart:convert';
import 'dart:io';
import 'package:Fahren123/data/api/api_checker.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:Fahren123/view/base/loading_widget.dart';
import 'package:dio/dio.dart' as ApiClient;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import 'api_constants.dart';
import 'api_error_response.dart';


class API_STRUCTURE {
  final String apiUrl;
  dynamic body;
  final bool isWantSuccessMessage;
  final String apiRequestMethod;
  String? contentType;

  API_STRUCTURE({
    this.body,
    required this.apiUrl,
    required this.apiRequestMethod,
    this.isWantSuccessMessage = false,
    this.contentType,
  });

  Future<Map<String, dynamic>> requestAPI({bool isShowLoading = false,bool isCheckAuthorization=true}) async {
    String api = "";
    if(isShowLoading){
      ApiLoader.show();
    }
    try {
      api = AppConstants.BASE_URL + apiUrl;
      Map<String, String> header = {};
      if(contentType != null){
        header.addAll({
          "Content-Type": contentType!
        });
      }
      if(Get.find<AuthController>().authRepo.isLoggedIn()){
        header.addAll({
        "Authorization": "${Get.find<AuthController>().authRepo.getAuthTokenType()} ${Get.find<AuthController>().authRepo.getAuthToken()}"
        });
      }
      header.addAll({
        "deviceType": Platform.isAndroid?'Android':"iOS",
        // "Accept": "application/json",
      });
      debugPrint("body:-> ${body?.fields}");
      debugPrint("body:-> ${body?.files}");
      debugPrint("header:-> $header");
      debugPrint("url:-> $api");


      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
        followRedirects: false,
        headers: header,
        /// Enable for testing complete status
        validateStatus: (int ?status){
          return (status??520)<530;
        }
      );
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(api, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
              ? await dio.post(api, data: body, options: options)
              /// Else for Delete Method
              :  apiRequestMethod == API_REQUEST_METHOD.DELETE
          ? await dio.delete(api, options: options)
      :await dio.put(api, data: body, options: options);
      debugPrint('response of $apiUrl----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      if(isCheckAuthorization){
        ApiChecker.checkUnAuthorization(response);
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = apiResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
        return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Server Bad response",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        e.message.split('[').first,
        isError: true,
      );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
            exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
          showCustomSnackBar(
            "Request cancelled",
            isError: true,
          );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          showCustomSnackBar(
            error,
            isError: true,
          );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      return exception;
    } catch (error) {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        error.toString().contains("SocketException")
            ? "Internet Connection Error"
            : error.toString(),
          isError: true,
      );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  Future<Map<String, dynamic>> requestCustomAPI({bool isShowLoading = false,}) async {
    if(isShowLoading){
      ApiLoader.show();
    }
    try {
      Map<String, String> header = {};
      if(contentType != null){
        header.addAll({
          "Content-Type": contentType!
        });
      }
      if(Get.find<AuthController>().authRepo.isLoggedIn()){
        header.addAll({
          "Authorization": "${Get.find<AuthController>().authRepo.getAuthTokenType()} ${Get.find<AuthController>().authRepo.getAuthToken()}"
        });
      }
      header.addAll({
        "deviceType": Platform.isAndroid?'Android':"iOS",
        "Accept": "application/json",
      });
      debugPrint("api:-> $apiUrl");
      debugPrint("body:-> $body");
      debugPrint("header:-> $header");
      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
          followRedirects: false,
          headers: header,
          /// Enable for testing complete status
          validateStatus: (int ?status){
            return (status??500)<500||status==2008;
          }
      );
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(apiUrl, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
          ? await dio.post(apiUrl, data: body, options: options)
      /// Else for Put Method
          : await dio.put(apiUrl, data: body, options: options);
      debugPrint("api :-> $apiUrl");
      debugPrint('response----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = apiResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
      return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      debugPrint("ApiClient.DioError:-> HttpException");
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Server Bad response",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      print("ApiClient.DioError:::->>> $e");
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        e.message,
        isError: true,
      );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
          exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
          showCustomSnackBar(
            "Request cancelled",
            isError: true,
          );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          showCustomSnackBar(
            error,
            isError: true,
          );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      print("exception:::->>> $exception");
      return exception;
    } catch (error) {
      print("error:::->>> $error");
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        error.toString().contains("SocketException")
            ? "Internet Connection Error"
            : error.toString(),
        isError: true,
      );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  apiResponseHandling(ApiClient.Response response) {
    response.data = response.data.runtimeType == String ? jsonDecode(response.data) : response.data;
    if (response.statusCode! >= 200 && response.statusCode !< 220) {
      if (isWantSuccessMessage) {
        showCustomSnackBar(
          response.data["message"],
          isError: !response.data['success'],
       );
      }
      debugPrint("response.data:= .> ${response.data}");
      if(response.data['success']){
        return {API_RESPONSE.SUCCESS: response.data};
      }else{
        return {API_RESPONSE.ERROR: response.data};
      }
      return {API_RESPONSE.SUCCESS: response.data};
    } else {
      String error='';
      showCustomSnackBar(
        response.data["message"],
        isError: true,
      );
      error = API_RESPONSE.GetErrorResponse(response.statusCode!) ?? "Unknown Status Response";
      return {API_RESPONSE.ERROR: error};
    }
  }
}