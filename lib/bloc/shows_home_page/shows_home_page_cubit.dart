import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_shows/data/models/shows_model.dart';

part 'shows_home_page_state.dart';

class ShowsHomePageCubit extends Cubit<ShowsHomePageBaseState> {
  ShowsHomePageCubit() : super(ShowsHomePageLoadingState());


  Future<void> loadShows() async {
    emit(ShowsHomePageLoadingState());

    await Future.delayed(Duration(milliseconds: 10000));

    emit(ShowsHomePageLoadedState(
      showsList: []
    ));

  }
}
