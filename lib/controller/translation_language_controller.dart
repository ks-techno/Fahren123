import 'dart:async';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/api/Api_Handler/api_error_response.dart';
import 'package:Fahren123/data/model/response/language_model.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:Fahren123/data/repository/auth_repo.dart';
import 'package:Fahren123/data/repository/language_repo.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationLanguageController extends GetxController implements GetxService {

  final LanguageRepo languageRepo;
  TranslationLanguageController({required this.languageRepo});

  List<TranslationLanguageModel>_languagesList=<TranslationLanguageModel>[];
  bool isDataFetching = false;

  List<TranslationLanguageModel> get languagesList =>_languagesList;

Future<Map<String,dynamic>> fetchLanguagesList({bool isFromInit=true}) async {
    isDataFetching = true;
    if(!isFromInit){
      update();
    }else{
      _languagesList.clear();
    }
    Map<String,dynamic> response = await languageRepo.getAllLanguages();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
      _languagesList = List<TranslationLanguageModel>.from(result.map((language){
        TranslationLanguageModel translationLanguage = TranslationLanguageModel.fromJson(language);
        try{
        translationLanguage.isSelected = Get.find<AuthController>().getLoginUserData()!.translationLanguage?.languageName.toLowerCase().trim() == translationLanguage.languageName.toLowerCase().trim();


        }catch(e){
     

        }
        return translationLanguage;
      }).toList());
    }
    isDataFetching = false;
    update();
    return response;
  }
Future<Map<String,dynamic>> updateTranslationLanguage({required TranslationLanguageModel translationLanguage, required bool isFromLogin}) async {
    Map<String,dynamic> response  = {};
      UserInfoModel? user = Get.find<AuthController>().getLoginUserData();

    
      if(user!=null){
        response = await languageRepo.updateTranslationLanguage(translationLanguage: translationLanguage.languageName.toLowerCase());
    if(response.containsKey(API_RESPONSE.SUCCESS)){

 user.translationLanguage = translationLanguage;
    
      Get.find<AuthController>().updateLoginUserData(user: user);
      }
      }
      
     
     
    

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      
      AuthRepo(sharedPreferences: sharedPreferences).setSelectedLanguage(translationLanguage);
    
      translationLanguage.isSelected = true;
       
        Get.offAllNamed(RouteHelper.getMainScreenRoute());
    return response;
  }
}