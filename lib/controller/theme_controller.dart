import 'package:Fahren123/theme/dark_theme.dart';
import 'package:Fahren123/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/app_constants.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  int _appTheme = 1;
  int get darkTheme => _appTheme;
  bool get isDarkMode => _appTheme==0;
  ThemeData get getTheme => _appTheme==0? dark(): light();
  void toggleTheme(){
    _appTheme = _appTheme==1?0:1;
    sharedPreferences.setInt(AppConstants.THEME, _appTheme);
    update();
  }
  void updateLightTheme({int isLightTheme= 1}) {
    if(isLightTheme!=_appTheme){
      _appTheme = isLightTheme;
      sharedPreferences.setInt(AppConstants.THEME, _appTheme);
      update();
    }
  }

  void _loadCurrentTheme() async {
    _appTheme = (sharedPreferences.getInt(AppConstants.THEME) ?? 1);
    debugPrint("_appTheme:-> $_appTheme");
    update();
  }
}
