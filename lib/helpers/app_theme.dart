import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/app_theme_enum.dart';
import 'app_colors.dart';


class AppThemes {

  static final ThemeData materialLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.pink,
    accentColor: AppColors.pink,
    colorScheme: ColorScheme.light(
      // FlatButton's text color
      primary: AppColors.pink, 
    ),
   
    buttonColor: AppColors.pink,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.pink,     //  <-- dark color
      textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.pink
      ),
    ),
    scaffoldBackgroundColor: Colors.white
  );


 

  static final CupertinoThemeData cupertinoLightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.pink,
  );

 
  

  static bool isDarkTheme(AppTheme appTheme) {
    return appTheme == AppTheme.system
      ?   WidgetsBinding.instance!.window.platformBrightness == Brightness.dark
      :   appTheme == AppTheme.dark;
  }



}
