part of 'show_flushbar_listener_cubit.dart';

class ShowFlushbarListenerState {

  final String message;
  final String? title;
  final int durationSeconds;
  
  ShowFlushbarListenerState({
    required this.message,
    this.title,
    this.durationSeconds = 3
  });

}


