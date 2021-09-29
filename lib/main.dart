import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'bloc/application/application_cubit.dart';
import 'bloc/authentication/authentication_cubit.dart';
import 'bloc/connectivity_monitor/connectivity_monitor_cubit.dart';
import 'bloc/login_page/login_page_cubit.dart';
import 'bloc/show_snackbnar_listener/show_snackbar_listener_cubit.dart';
import 'bloc/tv_shows_home_page/tv_shows_home_page_cubit.dart';
import 'core/app_config.dart';
import 'core/bloc_observer/app_bloc_observer.dart';
import 'core/localization/app_localization.dart';
import 'data/models/app_theme_enum.dart';
import 'data/repository/tv_shows_repository.dart';
import 'data/repository/user_repository.dart';
import 'helpers/app_theme.dart';
import 'helpers/flushbar_helper.dart';
import 'pages/login_page.dart';
import 'pages/tv_shows_home_page.dart';
import 'widgets/app_circular_progress_indicator.dart';

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
  late final TvShowsRepository _tvShowsRepository;
  late final ApplicationCubit applicationCubit;
  late final ConnectivityMonitorCubit connectivityMonitorCubit;
  late final AuthenticationCubit authenticationCubit;
  late final ShowSnackbarListenerCubit showSnackbarListenerCubit;

  static late final RootApp instance;


  RootApp({Key? key}) : super(key: key) {
    
    instance = this;

    _userRepository = UserRepositoryImpl();
    _tvShowsRepository = TvShowsRepositoryImpl();

    authenticationCubit = AuthenticationCubit(
      userRepository: _userRepository,
      tvShowsRepository: _tvShowsRepository
    );
    connectivityMonitorCubit = ConnectivityMonitorCubit();
    applicationCubit = ApplicationCubit(
      authenticationCubit: authenticationCubit,
      connectivityMonitorCubit: connectivityMonitorCubit
    );
    showSnackbarListenerCubit = ShowSnackbarListenerCubit();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    applicationCubit.applicationInitialize();
  }

  @override
  Widget build(BuildContext context) {
    // global scope cubits and repositories
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
          value: _userRepository
        ),
        RepositoryProvider<TvShowsRepository>.value(
          value: _tvShowsRepository
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ApplicationCubit>.value(
            value: applicationCubit,
          ),
          BlocProvider<AuthenticationCubit>.value(
            value: authenticationCubit
          ),
          BlocProvider<ConnectivityMonitorCubit>.value(
            value: connectivityMonitorCubit
          ),
          BlocProvider<ShowSnackbarListenerCubit>.value(
            value: showSnackbarListenerCubit
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
                body: BlocListener<ShowSnackbarListenerCubit, ShowSnackbarListenerState>(
                  listener: (context, state) {
                    AppFlushbarHelper.showFlushbar(
                      context: context, 
                      message: AppLocalizations.of(context).localizedString(state.message),
                      title: state.title != null ? AppLocalizations.of(context).localizedString(state.title!) : null,
                      durationSecodns: state.durationSeconds
                    );
                  },
                  child: Builder(
                    builder: (context) {
                      if (state is ApplicationInitializedState) {
                        return BlocConsumer<AuthenticationCubit, AuthenticationState>(
                          listener:  (context, state) {
                            if (state is AuthenticationUnauthenticatedState) {
                              // close any presented screens if they exists
                              final navigator = Navigator.of(context);
                              while(navigator.canPop()) {
                                navigator.pop();
                              }
                            }
                          },
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
                                create: (_) => TvShowsHomePageCubit(
                                  tvShowsRepository: context.read<TvShowsRepository>()
                                )..loadShows(),
                                child: TvShowsHomePage(),
                              );
                            }

                            // AuthenticationCheckState
                            return Center(
                              child: AppCircularProgressIndicator(),
                            );
                          },
                        );
                      }

                      // Application initializing state
                      return Center(
                        child: AppCircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              )
            );
          }
        ),
      ),
    );
  }

  void showSkackbar({
    required String message,
    String? title, 
    int durationSeconds = 3
  }) {
    showSnackbarListenerCubit.emit(ShowSnackbarListenerState(
      message: message,
      title: title,
      durationSeconds: durationSeconds
    ));
  }

  Future<void> signOut() async {
    await authenticationCubit.authenticationUnauthenticate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Called when the system puts the app in the background or returns the app to the foreground.
    super.didChangeAppLifecycleState(state);
    applicationCubit.onApplicationDidChangeLifecycleState(state);
  }

  @override
  void didChangePlatformBrightness() {
    //Called when the platform brightness changes.
    super.didChangePlatformBrightness();
    // applicationCubit.onApplicationDidChangePlatformBrightness();
  }
}
