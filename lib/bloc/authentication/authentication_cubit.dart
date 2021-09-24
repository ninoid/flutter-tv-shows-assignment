import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../data/repository/user_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  
  AuthenticationCubit({
    required UserRepository userRepository,
  }) :  _userRepository = userRepository,
        super(AuthenticationCheckState()) ;

  final UserRepository _userRepository;


  bool get isAuthenticated => state is AuthenticationAuthenticatedState;

  Future<void> authenticationCheck() async {
    debugPrint("--- Authentication check ---");
    emit(AuthenticationCheckState());

    final isOk = await _userRepository.isUserLoggedInAndSessionValid();
    if (isOk) {
      emit(AuthenticationAuthenticatedState());
    } else {
      emit(AuthenticationUnauthenticatedState());
    }
  }


  Future<void> authenticationAuthenticate() async {
    emit(AuthenticationAuthenticatedState());
  }

  Future<void> authenticationSignOut() async {
    emit(AuthenticationUnauthenticatedState());
  }


 

 




}
