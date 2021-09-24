import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'bloc/application/application_cubit.dart';
import 'bloc/authentication/authentication_cubit.dart';
import 'bloc/login_page/login_page_cubit.dart';
import 'bloc/shows_home_page/shows_home_page_cubit.dart';
import 'core/app_config.dart';
import 'core/bloc_observer/app_bloc_observer.dart';
import 'core/localization/app_localization.dart';
import 'data/models/app_theme_enum.dart';
import 'data/repository/user_repository.dart';
import 'helpers/app_theme.dart';
import 'pages/login_page.dart';
import 'pages/shows_home_page.dart';

void main() {
  
  runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        // await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
      } else {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) { };
    }

    Bloc.observer = AppBlocObserver();

    runApp(RootApp());

  }, (Object error, StackTrace stack) async {
    if (kReleaseMode) {
      // await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
    } else {
      debugPrint(error.toString());
    }
  });
}

class RootApp extends StatelessWidget with WidgetsBindingObserver {

  late final UserRepository _userRepository;
  late final ApplicationCubit _applicationCubit;
  late final AuthenticationCubit _authenticationCubit;

  RootApp({Key? key}) : super(key: key) {

    _userRepository = UserRepository();
    _authenticationCubit = AuthenticationCubit(
      userRepository: _userRepository
    );
    _applicationCubit = ApplicationCubit(
      authenticationCubit: _authenticationCubit
    );
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _applicationCubit.applicationInitialize();
  }


  @override
  Widget build(BuildContext context) {
    // global scope cubits and repositories
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
          value: _userRepository
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ApplicationCubit>.value(
            value: _applicationCubit,
          ),
          BlocProvider<AuthenticationCubit>.value(
            value: _authenticationCubit
          ),
        ],
        child: BlocBuilder<ApplicationCubit, ApplicationBaseState>(
          buildWhen: (previous, current) {
            return current is ApplicationInitializedState;
          }, 
          builder: (context, state) {
            final appLocale = (state is ApplicationInitializedState) ? state.locale : AppConfig.defaultLocale;
            final appTheme = (state is ApplicationInitializedState) ? state.appTheme : AppTheme.system;
            return PlatformApp(
              title: APP_NAME,
              debugShowCheckedModeBanner: false,
              material: (context, platformTarget) => MaterialAppData(
                theme: AppThemes.materialLightTheme,
              ),
              cupertino: (context, platformTarget) => CupertinoAppData(
                theme: AppThemes.cupertinoLightTheme 
              ),
              supportedLocales: AppConfig.supportedLocales,
              locale: appLocale,
              localizationsDelegates: [
                // A class which loads the translations from JSON files
                AppLocalizations.delegate,
                // Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,
                // Built-in localization of basic text for Cupertino widgets
                GlobalCupertinoLocalizations.delegate,
                // Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
              ],
              // Returns a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) {
                  return supportedLocales.first;
                }
                // Check if the current device locale is supported
                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
                // If the locale of the device is not supported, use the first one
                // from the list (English, in this case).
                return supportedLocales.first;
              },
              home: PlatformScaffold(
                body: Builder(
                  builder: (context) {

                    if (state is ApplicationInitializedState) {
                      return BlocBuilder<AuthenticationCubit, AuthenticationState>(
                        builder: (context, state) {
                          
                          if (state is AuthenticationUnauthenticatedState) {
                            return BlocProvider(
                              create: (_) => LoginPageCubit(
                                userRepository: context.read<UserRepository>(),
                                authenticationCubit: context.read<AuthenticationCubit>()
                              )..restoreCurrentUserCredentials(),
                              child: LoginPage(),
                            );
                          }

                          if (state is AuthenticationAuthenticatedState) {
                            return BlocProvider(
                              create: (_) => ShowsHomePageCubit()..loadShows(),
                              child: ShowsHomePage(),
                            );
                          }

                          // AuthenticationCheckState
                          return Center(
                            child: PlatformCircularProgressIndicator(),
                          );

                        },
                      );
                    }

                    // Application initializing state
                    return Center(
                      child: PlatformCircularProgressIndicator(),
                    );

                  },
                ),
              )
            );
          }
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Called when the system puts the app in the background or returns the app to the foreground.
    super.didChangeAppLifecycleState(state);
    // _applicationCubit.onApplicationDidChangeLifecycleState(state);
  }

  @override
  void didChangePlatformBrightness() {
    //Called when the platform brightness changes.
    super.didChangePlatformBrightness();
    // _applicationCubit.onApplicationDidChangePlatformBrightness();
  }


}