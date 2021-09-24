part of 'application_cubit.dart';

abstract class ApplicationBaseState extends Equatable {
  const ApplicationBaseState();

  @override
  List<Object?> get props => [];
}

// initial application state on application startup
class ApplicationInitializingState extends ApplicationBaseState {}

// application state after application is finally initialized
class ApplicationInitializedState extends ApplicationBaseState {

  const ApplicationInitializedState({
    required this.languageCode, 
    required this.appTheme,
  });

  final String languageCode;
  final AppTheme appTheme;

  Locale get locale => Locale(languageCode);

  ApplicationInitializedState copyWith({
    String? languageCode,
    AppTheme? appTheme,
  }) {
    return ApplicationInitializedState(
      languageCode: languageCode ?? this.languageCode, 
      appTheme: appTheme ?? this.appTheme,
    );
  }

  @override
  List<Object> get props => [
    languageCode, 
    appTheme
  ];

}



