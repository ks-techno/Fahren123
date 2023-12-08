import 'dart:async';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/api/Api_Handler/api_error_response.dart';
import 'package:Fahren123/data/model/response/category_model.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:Fahren123/data/repository/category_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  bool isDataFetching = false;
  List<QuestionCategory>_categoriesList = <QuestionCategory>[];
  List<QuestionCategory> get categories => _categoriesList;

  Future<Map<String,dynamic>> fetchCategories({bool isFromInitState=false}) async {
    isDataFetching = true;
    if(!isFromInitState){
      try{
        update();
      }catch(e){
        debugPrint("Exception:->>> $e");
      }
    }

    UserInfoModel? userInfoModel = Get.find<AuthController>().getLoginUserData();

    Map<String,dynamic> response = await categoryRepo.getCategories(language: userInfoModel!.translationLanguage!.languageName);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
      _categoriesList = List<QuestionCategory>.from(result.map((category) => QuestionCategory.fromJson(category)).toList());
    }
    isDataFetching = false;
    update();
    return response;
  }
}