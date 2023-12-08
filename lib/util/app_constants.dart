import 'package:Fahren123/util/images.dart';
import '../data/model/response/language_model.dart';

class AppConstants {
  static const String APP_NAME = 'Fahren123';
  static const double APP_VERSION = 1.0;
  static const int PASSWORD_MIN_LENGTH = 6;
  static const int TEXT_FIELD_MAX_LENGTH = 250;
  static const int DIGIT_TEXT_FIELD_MAX_LENGTH = 4;
  static const double padding =20;
  static const double avatarRadius =35;
  static bool learnInEnglish = false; 




  /// API Section
  static const String MEDIA_URL = 'https://adminpanel.fahren123.de';
  static const String BASE_URL = 'https://adminpanel.fahren123.de';
  // static const String BASE_URL = 'https://staging.fahren123.de';
  // static const String BASE_URL = 'https://adminpanel.wallarticle.com';
  // static const String STORAGE_URL = "$BASE_URL/uploads/";
  static const String STORAGE_URL = "$MEDIA_URL/";
  static const String API = '/api/';
  static const String APP_SETTINGS = '${API}configuration.php';
  static const String BANK_TRANSFER = '${API}bank_trasnfer.php';
  static const String AUTH = API;  //auth/';
  static const String PASSWORD = '/api/password/';
  static const String LOGIN = '${AUTH}login.php';
  // static const String SIGNUP = '${AUTH}register.php';
  static const String SIGNUP = '${AUTH}register_live.php';
  static const String LOGOUT = '${AUTH}logout.php?user_id=';
  static const String DELETE_ACCOUNT = '${AUTH}delete.php?id=';
  static const String FORGET = '/api/forgot_password.php';
  static const String GETBYID = '/api/get_user_by_id.php?user_id=';
  static const String RESET = '/api/reset_password.php';
  static const String CHANGE2 = '/api/change_password.php';
  static const String CHANGE_PASSWORD = '${PASSWORD}change';
  static const String OTP_VERIFy = '/api/otp-code/verify';
  static const String REGISTER_OTP_VERIFY = '${AUTH}otp_verify.php?';
  static const String forget_OTP_VERIFY = '/api/password_otp_verify.php?';
  static const String GET_CATEGORIES = '${API}categories.php';
  static const String GET_ALL_LANGUAGES = '${API}list_language.php';
  static const String UPDATE_TRANSLATION_LANGUAGE = '${API}update_language.php';
  static const String GET_QUESTIONS = '${API}question_details.php?category_id=';
  static const String GET_TEST1_QUESTIONS = '/api/test1.php?';
  static const String GET_TEST2_QUESTIONS = '/api/test2.php?';
  static const String GET_TRIAL_QUESTIONS = '${API}trial_questions.php?language=';
  static const String CHECK_REFERRAL = '/api/check_referral.php';
  static const String GET_PAYMENT_PLAN = '/api/payment_plan.php';
  static const String SAVE_PAYMENT_PLAN = '/api/save_paln.php?';
  static const String STRIPE_PAYMENT = '/api/stripe_payments.php?';
  static const String GET_PERFORMANCE = '/api/get_performance.php?';
  static const String GET_NOTIFICATION = '/api/notifications.php?';
  static const String SAVE_PERFORMANCE = '/api/save_performance.php';
static const String READ_NOTIFICATION = '/api/save_notification.php?';


  // Shared Key
  static const String THEME = 'GlowSolarTheme';
  static const String LOGIN_USER = 'LoginUser';
  static const String LOGIN_USER_PASSWORD = 'LoginUserPassword';
  static const String CATEGORY_QUESTON_TO_VIEW_INDEX = 'nextCategoryToView';
  static const String CATEGORY_QUESTONS_VIEWED = 'categoryQuestionsViewed';
  static const String SELECTED_LANGUAGE = 'SelectedLanguage';
  static const String COUNTRY_CODE = 'GlowSolarCountryCode';
  static const String LANGUAGE_CODE = 'GlowSolarLanguageCode';
  static const String USER_PASSWORD = 'GlowSolarUserPassword';
  static const String USER_ADDRESS = 'GlowSolarUserAddress';
  static const String USER_NUMBER = 'GlowSolarUserNumber';
  static const String USER_COUNTRY_CODE = 'GlowSolarUserCountryCode';
  static const String NOTIFICATION = 'GlowSolarNotification';
  static const String SEARCH_HISTORY = 'GlowSolarSearchHistory';
  static const String INTRO = 'GlowSolarIntro';
  static const String NOTIFICATION_COUNT = 'GlowSolarNotificationCount';


  // static List<TranslationLanguageModel> languages = [
  //   TranslationLanguageModel(
  //       imageUrl: Images.english,
  //       languageName: 'English',
  //       countryCode: 'US',
  //       languageCode: 'en', countryName: ''),
  //   // LanguageModel(
  //   //     imageUrl: Images.hongkong,
  //   //     languageName: '中文 香港',
  //   //     countryCode: 'HK',
  //   //     languageCode: 'zh-hk'),
  // ];
}
