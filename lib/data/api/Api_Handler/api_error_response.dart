// ignore_for_file: non_constant_identifier_names

import 'api_constants.dart';

class API_RESPONSE{
  static String ?GetErrorResponse(int errorCode){
    Map<int,String>responseError = API_ERROR_RESPONSE.firstWhere((error) => error.containsKey(errorCode));
    return responseError[errorCode];
  }
  static String SUCCESS = "Success";
  static String ERROR = "Error";
  static String EXCEPTION = "Exception";
}