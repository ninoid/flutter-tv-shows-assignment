import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppColors {

  AppColors._();


  static const pink = Color(0xffff758c);
  static final red = Platform.isIOS ? CupertinoColors.systemRed : Colors.red;
  static final grey = Platform.isIOS ? CupertinoColors.systemGrey : Colors.grey;
  static const imagePlaceholderColor = Color(0xffeeeeee);
  static final skeletonAnimationShimmerColor = Colors.white.withOpacity(0.2);
  static final flushbarBackgroundColor = Platform.isIOS ? Color(0xff323136) : Colors.grey[800]!;
 
  
}
