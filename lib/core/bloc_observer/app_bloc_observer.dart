import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';


class AppBlocObserver extends BlocObserver  {
  
  AppBlocObserver();

  final _shouldDebugPrint = false; //!kReleaseMode;


  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _debugPrint("--- AppBlocObserver onCreate ${bloc.toString()}");
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _debugPrint("--- AppBlocObserver onEvent ${bloc.toString()} -> ${event?.toString() ?? "-"}");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _debugPrint("--- AppBlocObserver onError ${bloc.toString()} -> ${error.toString()}");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _debugPrint("--- AppBlocObserver onChange ${bloc.toString()} -> ${change.toString()}");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _debugPrint("--- AppBlocObserver onTransition ${bloc.toString()} -> ${transition.toString()}");
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _debugPrint("--- AppBlocObserver onClose ${bloc.toString()}");
  }


  void _debugPrint(String message) {
    if (_shouldDebugPrint) {
      debugPrint(message);
    }
  }

}
