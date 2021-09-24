
import 'dart:io' show Platform;

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app_colors.dart';


class AppFlushbarHelper {

  AppFlushbarHelper._();

  static void showFlushbar({
    required BuildContext context,
    required String message,
    String? title,
    int durationSecodns = 4,
    bool showAboveBottomNavigationBar = false,
  }) {
    
    final marginLTR = Platform.isIOS ? 8.0 : 0.0;
    final marginBottom = (showAboveBottomNavigationBar && Platform.isAndroid) ? kBottomNavigationBarHeight : 0.0;
    final margin = EdgeInsets.fromLTRB(marginLTR, marginLTR, marginLTR, marginLTR + marginBottom);

    Flushbar(
      title: title,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: margin,
      borderRadius: BorderRadius.circular(Platform.isIOS ? 8 : 0) ,
      duration: Duration(seconds: durationSecodns),
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: Platform.isIOS || !showAboveBottomNavigationBar,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      animationDuration: Duration(milliseconds: 200),
      backgroundColor:AppColors.flushbarBackgroundColor,
      // boxShadows: [BoxShadow(color: AppColors.flushbarBackgroundColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      // backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.teal]),
      // barBlur: 0,
    ).show(context);
  }

}