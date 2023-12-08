import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/api/Api_Handler/api_call_Structure.dart';
import 'package:Fahren123/data/api/Api_Handler/api_constants.dart';
import 'package:get/get.dart';
import '../../util/app_constants.dart';

class LanguageRepo {

  Future<Map<String, dynamic>> getAllLanguages() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.GET_ALL_LANGUAGES,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> updateTranslationLanguage({required String translationLanguage}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.UPDATE_TRANSLATION_LANGUAGE}?language=$translationLanguage&id=${Get.find<AuthController>().authRepo.getLoginUserData()!.id}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

}
