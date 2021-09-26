part of 'show_snackbar_listener_cubit.dart';

class ShowSnackbarListenerState {

  final String message;
  final String? title;
  final int durationSeconds;
  
  ShowSnackbarListenerState({
    required this.message,
    this.title,
    this.durationSeconds = 3
  });

}


