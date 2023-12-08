import 'package:Fahren123/controller/app_settings_controller.dart';
import 'package:Fahren123/controller/question_controller.dart';
import 'package:Fahren123/controller/translation_language_controller.dart';
import 'package:Fahren123/data/repository/app_settings_repo.dart';
import 'package:Fahren123/data/repository/auth_repo.dart';
import 'package:Fahren123/data/repository/category_repo.dart';
import 'package:Fahren123/data/repository/language_repo.dart';
import 'package:Fahren123/data/repository/question_repo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/auth_controller.dart';
import '../controller/categories_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';


// Future<Map<String, Map<String, String>>> init() async {
Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => CategoryRepo());
  Get.lazyPut(() => QuestionRepo());
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => AppSettingsRepo());
  // Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Repository
  // Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  // Get.lazyPut(() => LanguageRepo());


  // Controller

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  // Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => AppSettingsController(appSettingsRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => TranslationLanguageController(languageRepo: Get.find()));
  Get.lazyPut(() => QuestionController(questionRepo: Get.find()));

  // Retrieving localized data
  // Map<String, Map<String, String>> languages = {};
  // for(TranslationLanguageModel languageModel in AppConstants.languages) {
  //   String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
  //   Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
  //   Map<String, String> jsonMap = {};
  //   mappedJson.forEach((key, value) {
  //     jsonMap[key] = value.toString();
  //   });
  //   languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonMap;
  // }
  // return languages;
  return;
}
