import 'dart:convert';
import 'package:Fahren123/data/api/Api_Handler/api_call_Structure.dart';
import 'package:Fahren123/data/api/Api_Handler/api_constants.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../enums/otp_verify_type.dart';
import '../../util/app_constants.dart';

class CategoryRepo {
  CategoryRepo();
  Future<Map<String, dynamic>> getCategories({required String language}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.GET_CATEGORIES}?language=${language.toLowerCase()}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
}
