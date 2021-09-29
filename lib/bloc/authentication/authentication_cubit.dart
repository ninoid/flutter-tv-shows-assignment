import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../data/repository/tv_shows_repository.dart';

import '../../data/repository/user_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  
  AuthenticationCubit({
    required UserRepository userRepository,
    required TvShowsRepository tvShowsRepository
  }) :  _userRepository = userRepository,
        _tvShowsRepository = tvShowsRepository,
        super(AuthenticationCheckState()) ;

  final UserRepository _userRepository;
  final TvShowsRepository _tvShowsRepository;

  bool get isAuthenticated => state is AuthenticationAuthenticatedState;

  Future<void> authenticationCheck() async {
    debugPrint("--- Authentication check ---");
    emit(AuthenticationCheckState());

    final isOk = await _userRepository.isUserLoggedInAndSessionValid();
    if (isOk) {
      emit(AuthenticationAuthenticatedState());
    } else {
      await _unauthenticate();
    }
  }

  Future<void> authenticationAuthenticate() async {
    emit(AuthenticationAuthenticatedState());
  }

  Future<void> authenticationUnauthenticate() async {
    await _unauthenticate();
  }

  Future<void> _unauthenticate() async {
    await _userRepository.clearAllAuthenticationCache();
    await _tvShowsRepository.deleteAllLocalStoreCache();
    emit(AuthenticationUnauthenticatedState());
  }

}
