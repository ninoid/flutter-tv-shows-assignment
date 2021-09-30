import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
        // try restore from local store - offline mode
        tvShows = await _tryGetTvShowsFromLocalStore();
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    if (!success) {
      RootApp.instance.showFlushbar(message: errorMessage);
    } else {
      await _trySaveTvShowToLocalStore(tvShows!);
    }
    
    emit(TvShowsHomePageLoadedState(
      showsList: tvShows ?? []
    ));

  }

  Future<void> _trySaveTvShowToLocalStore(List<TvShowModel> tvShows) async {
    debugPrint("Saving to Sembast db");
    try {
      await _tvShowsRepository.saveTvShowsToLocalStore(tvShows);
      debugPrint("Tv shows saved to Sembast NoSQL db");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<TvShowModel>?> _tryGetTvShowsFromLocalStore() async {
    debugPrint("Reading Tv Shows from Sembast db");
    try {
      return await _tvShowsRepository.getLocalStoreTvShows();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
