import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/app_theme_enum.dart';
import 'app_colors.dart';


class AppThemes {

  static final ThemeData materialLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.appPink,
    accentColor: AppColors.appPink,
    colorScheme: ColorScheme.light(
      // FlatButton's text color
      primary: AppColors.appPink, 
    ),
   
    buttonColor: AppColors.appPink,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.appPink,     //  <-- dark color
      textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.appPink
      ),
    ),
    scaffoldBackgroundColor: Colors.white
  );


 

  static final CupertinoThemeData cupertinoLightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.appPink,
  );

 
  

  static bool isDarkTheme(AppTheme appTheme) {
    return appTheme == AppTheme.system
      ?   WidgetsBinding.instance!.window.platformBrightness == Brightness.dark
      :   appTheme == AppTheme.dark;
  }



}
