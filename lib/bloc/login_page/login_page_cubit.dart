import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_shows/data/models/button_status_enum.dart';
import 'package:tv_shows/data/models/current_user_login_credentials.dart';
import 'package:tv_shows/helpers/utils.dart';

import '../../data/repository/user_repository.dart';
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
      emit(LoginPageInformUserWithSnackbarState(
        message: "An error occured while restoring current user credientals."
      ));
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
    String? loginErrorMessage;
    try {
      await Future.delayed(Duration(milliseconds: 4000));
      loginErrorMessage = "aaaaa";
      loginSuccessful = true;
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
      emit(LoginPageInformUserWithSnackbarState(message: loginErrorMessage ?? "Whoooops, login failed"));
      emit(currentState.copyWith(
        isLoginInProgress: false
      ));
    }
  }



}
