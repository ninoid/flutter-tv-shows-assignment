import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../helpers/utils.dart';

part 'connectivity_monitor_state.dart';

class ConnectivityMonitorCubit extends Cubit<ConnectivityMonitorState> {
  
  ConnectivityMonitorCubit() : super(ConnectivityMonitorState.initial()) {
    checkConnectivity();
  }

  StreamSubscription<ConnectivityResult>? _connectivityListener;

  Future<void> checkConnectivity() async {
    debugPrint("--- connectivity check ---");
    _connectivityListener?.cancel();
    // set listener
    _connectivityListener = Connectivity().onConnectivityChanged.listen(
      (connectivityResult) async { 
        final isInternetAvailable = await Utils.isInternetAvailable();
        emit(ConnectivityMonitorState(
          connectivityStatus: connectivityResult,
          isInternetAvailable: isInternetAvailable
        ));
        debugPrint("--- connectivity changed ---");
        _printConnectivityStatus();
      }
    );
    // check now
    final connectivityStatus = await Connectivity().checkConnectivity();
    final isInternetAvailable = await Utils.isInternetAvailable();
    emit(ConnectivityMonitorState(
      connectivityStatus: connectivityStatus,
      isInternetAvailable: isInternetAvailable
    ));
    _printConnectivityStatus();
  }

  void cancelConnectivityListener() {
    _connectivityListener?.cancel();
    _connectivityListener = null;
    debugPrint("Connectivity subscription/listener canceled");
  }


  @override
  Future<void> close() {
    cancelConnectivityListener();
    return super.close();
  }

  void _printConnectivityStatus() {
    debugPrint("Connectivity status: ${state.connectivityStatus}");
    debugPrint("Is internet available: ${state.isInternetAvailable}");
  }

}
