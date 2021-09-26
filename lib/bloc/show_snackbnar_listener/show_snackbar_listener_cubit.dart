import 'package:bloc/bloc.dart';

part 'show_snackbar_listener_state.dart';

class ShowSnackbarListenerCubit extends Cubit<ShowSnackbarListenerState> {
  ShowSnackbarListenerCubit() : super(ShowSnackbarListenerState(message: ""));
}
