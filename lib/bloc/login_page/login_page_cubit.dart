import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/current_user_login_credentials.dart';
import '../../data/repository/user_repository.dart';
import '../../helpers/utils.dart';
import '../../main.dart';
import '../authentication/authentication_cubit.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageBaseState> {

  final UserRepository _userRepository;
  final AuthenticationCubit _authenticationCubit;


  LoginPageCubit({
    required UserRepository userRepository,
    required AuthenticationCubit authenticationCubit
  }) :  _userRepository = userRepository,
        _authenticationCubit = authenticationCubit,
        super(LoginPageRestoringUserCredentialsState());

  static const _rememberCurrentUserSharedPrefsSettingKey = "loginRememberCurrentUser";

  String _email = "";
  String _password = "";


  Future<void> restoreCurrentUserCredentials() async {
    emit(LoginPageRestoringUserCredentialsState());
    _email = "";
    _password = "";
    var isRememberMeChecked = false;
    try {
      final sp = await SharedPreferences.getInstance();
      isRememberMeChecked = sp.getBool(_rememberCurrentUserSharedPrefsSettingKey) ?? false;
      CurrentUserCredientalsModel? currentUserCredientalsModel;
      if (isRememberMeChecked) {
        currentUserCredientalsModel = await _userRepository.restoreCurrentUserLoginCredientals();
        _email = currentUserCredientalsModel?.email.trim() ?? "";
        _password = currentUserCredientalsModel?.password ?? "";
      }
    } catch (e) {
      RootApp.sharedInstance.showSkackbar(
        message: "An error occured while restoring current user credientals."
      );
    }
    emit(LoginPageState(
      initialEmail: _email,
      initialPassword: _password,
      isRememberMeChecked: isRememberMeChecked
    ));
    _validateLoginInput();
  }

  void emailInputTextChanged(String newValue) {
    _email = newValue;
    _validateLoginInput();
  }

  void passwordInputTextChanged(String newValue) {
    _password = newValue;
    _validateLoginInput();
  }

  Future<void> rememberMeCheckboxPressed(bool newValue) async {
    final currentState = state as LoginPageState;
    emit(currentState.copyWith(
      isRememberMeChecked: newValue
    ));
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_rememberCurrentUserSharedPrefsSettingKey, newValue);
  }

  Future<void> showOrHidePasswordButtonPressed() async {
    final currentState = state as LoginPageState;
    emit(currentState.copyWith(
      showPassword: !currentState.showPassword
    ));
  }


  void _validateLoginInput() {
    final isValid = Utils.isEmailAddresValid(_email) && _password.trim().isNotEmpty;
    final currentState = state as LoginPageState;
    emit(currentState.copyWith(
      isLoginButtonEnabled: isValid
    ));
  }


  Future<void> loginButtonPressed() async {
    var currentState = state as LoginPageState;
    currentState = currentState.copyWith(
      isLoginInProgress: true
    );
    emit(currentState);
    var loginSuccessful = false;
    String loginErrorMessage = "";
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final apiResult = await _userRepository.webApiUserLoginWithEmailAndPassword(email: _email, password: _password);
      final token = apiResult.result ?? ""; 
      final isSuccess = apiResult.isStatusCodeOk && token.isNotEmpty;  
      if (!isSuccess) {
        loginErrorMessage = apiResult.dioResponse?.statusCode == 401 
          ? "invalid_username_or_password"
          : apiResult.errorMessage;
      }                                                                                  
      await _userRepository.saveWebApiAuthTokenToSharedPrefs(token);
      loginSuccessful = isSuccess;
    } catch (e) {
      loginErrorMessage = e.toString(); 
    }

    if (loginSuccessful) {
      try {
        // try to save current login credientals
        // but do nothing if save to sembast fail 
        if (currentState.isRememberMeChecked) {
          final persistModel = CurrentUserCredientalsModel(email: _email, password: _password);
          await _userRepository.saveCurrentUserLoginCredientalsModel(persistModel);
        } else {
          await _userRepository.removeCurrentUserLoginCredientalsModel();
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {							// Always clean up, even if case of exception
        // finaly go to home page
        _authenticationCubit.authenticationAuthenticate();
      }

    } else {
      RootApp.sharedInstance.showSkackbar(message: loginErrorMessage);
      emit(currentState.copyWith(
        isLoginInProgress: false
      ));
    }
  }



}
