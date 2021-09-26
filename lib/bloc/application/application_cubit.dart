import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/authentication_cubit.dart';
import '../../core/app_config.dart';

import '../../data/models/app_theme_enum.dart';

part 'application_state.dart';


class ApplicationCubit extends Cubit<ApplicationBaseState> {

  ApplicationCubit({
    required AuthenticationCubit authenticationCubit
  }) : _authenticationCubit = authenticationCubit,
      super(ApplicationInitializingState());


  final AuthenticationCubit _authenticationCubit;
  late final PackageInfo _packageInfo;
  PackageInfo get packageInfo  => _packageInfo;


  Future<void> applicationInitialize() async {
    debugPrint("--- Application Initialize ---");
    await _initializeSembastDb();
    final languageCode = await _initializeLocalization();
    final appTheme = await _initializeAppTheme();
    _packageInfo = await PackageInfo.fromPlatform(); // used for app version
    // await Future.delayed(Duration(milliseconds: 2000));
    _authenticationCubit.authenticationCheck();
    emit(ApplicationInitializedState(languageCode: languageCode, appTheme: appTheme));
  }


  Future<void> _initializeSembastDb() async {
    debugPrint("Initializing sembast database");
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    await appDocumentsDir.create(recursive: true);
    final sembastDbPath = p.join(appDocumentsDir.path, "sembast.db");
    debugPrint("Sembast DB path: $sembastDbPath");
    final sembastDb = await databaseFactoryIo.openDatabase(sembastDbPath);
    GetIt.instance.registerSingleton<Database>(sembastDb);
  }

  Future<String> _initializeLocalization() async {
    // we can restore user language setting here
    // eg. read for lang code from shared prefs
    await Future.delayed(Duration(milliseconds: 100));
    return "en";
  }

  Future<AppTheme> _initializeAppTheme() async {
    final sp = await SharedPreferences.getInstance();
    var appThemeIndex = sp.getInt(APP_THEME_ID);
    if (appThemeIndex == null) {
      appThemeIndex = AppTheme.system.index;
      await sp.setInt("appThemeId", appThemeIndex);
    }
    return AppTheme.values[appThemeIndex];
  }

 

  Future<void> changeAppLanguage(String langCode) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(LANG_CODE, langCode);
    final currentState = state as ApplicationInitializedState;
    emit(currentState.copyWith(languageCode: langCode));
  }

   Future<void> changeAppTheme(AppTheme appTheme) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(APP_THEME_ID, appTheme.index);
    final currentState = state as ApplicationInitializedState;
    emit(currentState.copyWith(appTheme: appTheme));
  }


  
}
