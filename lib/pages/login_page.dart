import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/login_page/login_page_cubit.dart';
import '../core/app_config.dart';
import '../core/localization/app_localization.dart';
import '../helpers/app_colors.dart';
import '../helpers/flushbar_helper.dart';
import '../widgets/app_circular_progress_indicator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginPageCubit, LoginPageBaseState>(
      listenWhen: (previous, current) {
        return current is LoginPageInformUserWithSnackbarState;
      },
      listener: (context, state) {
        if (state is LoginPageInformUserWithSnackbarState) {
          AppFlushbarHelper.showFlushbar(
            context: context, 
            message: AppLocalizations.of(context).localizedString(state.message)
          );
        }
      },
      buildWhen: (previous, current) {
        return  current is LoginPageRestoringUserCredentialsState ||
                current is LoginPageState;
      },
      builder: (context, state) {
        
        if (state is LoginPageRestoringUserCredentialsState) {
          return Center(
            child: PlatformCircularProgressIndicator()
          );
        }

        if (state is LoginPageState) {

          return GestureDetector(
            onTap: () {
              _unfocusTextFields();
            },
            child: PlatformScaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 60
                        ),
                        SvgPicture.asset(
                          "assets/svg/img-login-logo.svg",
                          height: 100,
                        ),
                        SizedBox(
                          height: 50
                        ),
                        TextFormField(
                          initialValue: state.initialEmail,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !state.isLoginInProgress,
                          autocorrect: false,
                          autofocus: false,
                          maxLength: 100,
                          maxLines: 1,
                          minLines: 1,
                          cursorColor: AppColors.pink,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).localizedString("Email"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey, width: 1),   
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey, width: 1),   
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey, width: 1),   
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey.withOpacity(0.75), width: 1),   
                            ),
                            // errorBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: AppColors.red, width: 1),   
                            // ),
                            // focusedErrorBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: AppColors.red, width: 2),   
                            // ),
                            counter: SizedBox.shrink(),
                          ),
                          onChanged: (value) {
                            context.read<LoginPageCubit>().emailInputTextChanged(value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: state.initialPassword,
                          focusNode: _passwordFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: !state.showPassword,
                          enabled: !state.isLoginInProgress,
                          autocorrect: false,
                          autofocus: false,
                          maxLength: 100,
                          maxLines: 1,
                          minLines: 1,
                          cursorColor: AppColors.pink,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).localizedString("Password"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey, width: 1),   
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey, width: 1),   
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey, width: 1),   
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey.withOpacity(0.75), width: 1),   
                            ),
                            // errorBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: AppColors.red, width: 1),   
                            // ),
                            // focusedErrorBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: AppColors.red, width: 2),   
                            // ),
                            counter: SizedBox.shrink(),
                            suffixIconConstraints: BoxConstraints(),
                            suffixIcon: PlatformIconButton(
                              padding: EdgeInsets.zero,
                              material: (_,__)=> MaterialIconButtonData(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                              icon: SvgPicture.asset(
                                state.showPassword ? "assets/svg/ic-characters-hide.svg" : "assets/svg/ic-hide-password.svg",
                                height: state.showPassword ? 22 : 24, // tweak height since svg different
                                fit: BoxFit.fitHeight,
                                color: !state.isLoginInProgress
                                  ? AppColors.pink
                                  : AppColors.grey.withOpacity(0.75)
                              ),
                              onPressed: !state.isLoginInProgress
                                ? () {
                                    context.read<LoginPageCubit>().showOrHidePasswordButtonPressed();
                                    _unfocusTextFields();
                                  }
                                : null
                            )
                          ),
                          onChanged: (value) {
                            context.read<LoginPageCubit>().passwordInputTextChanged(value);
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context).localizedString("Remember me")
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.all(0),
                          dense: false,
                          autofocus: false,
                          activeColor: AppColors.pink,
                          checkColor: Colors.white,
                          value: state.isRememberMeChecked,
                          onChanged: !state.isLoginInProgress
                            ? (bool? newValue) {
                                context.read<LoginPageCubit>().rememberMeCheckboxPressed(newValue ?? false);
                              }
                            : null,
                        ), //Check
                        SizedBox(
                          height: 32,
                        ),
                        PlatformButton(
                          onPressed: state.isLoginButtonEnabled && !state.isLoginInProgress 
                          ? () {
                              _unfocusTextFields();
                              context.read<LoginPageCubit>().loginButtonPressed();
                            }
                          : null,
                          padding: EdgeInsets.symmetric(
                            horizontal: DEFAULT_CONTENT_PADDING,
                            vertical: 12
                          ),
                          color: AppColors.pink,
                          child: Builder(
                            builder: (context) {
                              if (state.isLoginInProgress) {
                                return AppCircularProgressIndicator(
                                  materialColor: Colors.white,
                                  materialRadius: 12,
                                  cupertinoRadius: 12,
                                );
                              }
                              return Text(
                                AppLocalizations.of(context).localizedString("Log In").toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14
                                )
                              );
                            },
                          ),
                          material: (_,__) => MaterialRaisedButtonData(
                            elevation: 0,
                            disabledElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          cupertinoFilled: (_,__) => CupertinoFilledButtonData(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // should never reach here...
        return Container();
      },
    );
  }

  void _unfocusTextFields() {
    if (_emailFocusNode.hasFocus) {
      _emailFocusNode.unfocus();
    } else if (_passwordFocusNode.hasFocus) {
      _passwordFocusNode.unfocus();
    }
  }
}