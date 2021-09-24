import 'package:flutter/foundation.dart';

@immutable
class AppLanguage {

  final String languageCode;
  final String languageName;
  final String languageNameEn;
  final bool isActive;
  final String localSvgFlagImageAssetPath;
  final int displayOrder;

  const AppLanguage({
    required this.languageCode, 
    required this.languageName,
    required this.languageNameEn,
    required this.isActive, 
    required this.localSvgFlagImageAssetPath,
    required this.displayOrder
  });

}