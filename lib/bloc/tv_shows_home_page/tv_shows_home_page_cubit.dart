import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/app_config.dart';
import '../../data/models/tv_shows_model.dart';
import '../../data/repository/tv_shows_repository.dart';
import '../../main.dart';

part 'tv_shows_home_page_state.dart';

class TvShowsHomePageCubit extends Cubit<TvShowsHomePageState> {

  final TvShowsRepository _tvShowsRepository;

  TvShowsHomePageCubit({
    required TvShowsRepository tvShowsRepository
  }) 
    : _tvShowsRepository = tvShowsRepository, 
      super(TvShowsHomePageLoadingState());


  Future<void> loadShows() async {
    emit(TvShowsHomePageLoadingState());

    List<TvShowModel>? tvShows;
    String errorMessage = "";
    bool success = false;
    try {
      final apiResult = await _tvShowsRepository.getWebApiTvShows();
      tvShows = apiResult.result; 
      success = apiResult.isStatusCodeOk && apiResult.result != null;
      if (!success) {
        errorMessage = apiResult.error ?? ERROR_GENERIC_SOMETHING_WENT_WRONG;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    if (!success) {
      RootApp.instance.showSkackbar(message: errorMessage);
    }
    
    emit(TvShowsHomePageLoadedState(
      showsList: tvShows ?? []
    ));

  }
}
