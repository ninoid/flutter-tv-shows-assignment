import 'package:bloc/bloc.dart';

part 'show_flushbar_listener_state.dart';

class ShowFlushbarListenerCubit extends Cubit<ShowFlushbarListenerState> {
  ShowFlushbarListenerCubit() : super(ShowFlushbarListenerState(message: ""));
}
