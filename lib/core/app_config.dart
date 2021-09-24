import 'package:flutter/material.dart';

import '../data/models/app_language.dart';

const DEFAULT_CONTENT_PADDING = 16.0;
const String APP_NAME = 'TV Shows';
const String LANG_CODE = "lang_code";
const String APP_THEME_ID = "app_theme_id";


class AppConfig {

  AppConfig._();

  static final AppLanguage defaultAppLanguage = appLanguages[0];

  static Locale get defaultLocale => Locale(defaultAppLanguage.languageCode);

  static final String defaultLanguageCode = defaultAppLanguage.languageCode;

  static final List<Locale> supportedLocales = supportedLanguageCodes.map((e) => Locale(e)).toList();

  static final List<String> supportedLanguageCodes = appLanguages.map((e) => e.languageCode).toList();

  static final List<AppLanguage> appLanguages = _appLanguages.where((e) => e.isActive).toList();

  static List<AppLanguage> get _appLanguages => [
    AppLanguage(
      languageCode: "en", 
      languageName: "English",
      languageNameEn: "English",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/united_kingdom.svg",
      displayOrder: 1
    ),
    AppLanguage(
      languageCode: "de",
      languageName: "Deutsch",
      languageNameEn: "German",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/germany.svg",
      displayOrder: 2
    ),
    AppLanguage(
      languageCode: "hr",
      languageName: "Hrvatski",
      languageNameEn: "Croatian",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/croatia.svg",
      displayOrder: 3
    ),
    AppLanguage(
      languageCode: "es",
      languageName: "Español",
      languageNameEn: "Spanish",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/spain.svg",
      displayOrder: 4
    ),
    AppLanguage(
      languageCode: "fr",
      languageName: "Français",
      languageNameEn: "French",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/france.svg",
      displayOrder: 5
    ),
    AppLanguage(
      languageCode: "ja",
      languageName: "日本語",
      languageNameEn: "Japanese",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/japan.svg",
      displayOrder: 6
    ),
    AppLanguage(
      languageCode: "nl",
      languageName: "Dutch",
      languageNameEn: "Nederlands",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/netherlands.svg",
      displayOrder: 7
    ),
    AppLanguage(
      languageCode: "da",
      languageName: "Dansk",
      languageNameEn: "Danish",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/denmark.svg",
      displayOrder: 8
    ),
    AppLanguage(
      languageCode: "sv",
      languageName: "Svenska",
      languageNameEn: "Swedish",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/sweden.svg",
      displayOrder: 9
    ),
    AppLanguage(
      languageCode: "no",
      languageName: "Norsk",
      languageNameEn: "Norwegian",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/norway.svg",
      displayOrder: 10
    ),
    AppLanguage(
      languageCode: "it",
      languageName: "Italiano",
      languageNameEn: "Italian",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/italy.svg",
      displayOrder: 11
    ),
    AppLanguage(
      languageCode: "ru",
      languageName: "Русский",
      languageNameEn: "Russian",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/russia.svg",
      displayOrder: 12
    ),
    AppLanguage(
      languageCode: "tr",
      languageName: "Türkçe",
      languageNameEn: "Turkish",
      isActive: true, 
      localSvgFlagImageAssetPath: "assets/svg/countrys_flags/turkey.svg",
      displayOrder: 13
    ),
  ]..sort((e1, e2) => e1.displayOrder.compareTo(e2.displayOrder));
}
