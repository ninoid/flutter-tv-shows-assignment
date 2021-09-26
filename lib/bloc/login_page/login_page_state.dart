part of 'login_page_cubit.dart';

abstract class LoginPageBaseState extends Equatable {
  const LoginPageBaseState();

  @override
  List<Object?> get props => [];
}

class LoginPageRestoringUserCredentialsState extends LoginPageBaseState {}


class LoginPageState extends LoginPageBaseState {

  final String initialEmail;
  final String initialPassword;
  final bool isRememberMeChecked;
  final bool showPassword;
  final bool isLoginButtonEnabled;
  final bool isLoginInProgress; // flag when user submits login button and api call is in progress..

  const LoginPageState({
    this.initialEmail = "",
    this.initialPassword = "",
    this.isRememberMeChecked = false,
    this.showPassword = false,
    this.isLoginButtonEnabled = false,
    this.isLoginInProgress = false
  });


  LoginPageState copyWith({ 
    bool? isRememberMeChecked, 
    bool? showPassword,
    bool? isLoginButtonEnabled,
    bool? isLoginInProgress
  }) {
    return LoginPageState(
      isRememberMeChecked: isRememberMeChecked ?? this.isRememberMeChecked,
      showPassword: showPassword ?? this.showPassword,
      isLoginButtonEnabled: isLoginButtonEnabled ?? this.isLoginButtonEnabled,
      isLoginInProgress: isLoginInProgress ?? this.isLoginInProgress,
      initialEmail: this.initialEmail,
      initialPassword: this.initialPassword
    );
  }

  @override
  List<Object> get props => [
    isRememberMeChecked,
    showPassword,
    isLoginButtonEnabled,
    isLoginInProgress
  ];

}