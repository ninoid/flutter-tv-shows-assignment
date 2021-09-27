import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tv_shows/core/app_config.dart';
import 'package:tv_shows/data/models/episode_comment_model.dart';
import 'package:tv_shows/data/models/episode_model.dart';
import 'package:tv_shows/data/repository/tv_shows_repository.dart';

part 'episode_comments_page_state.dart';

class EpisodeCommentsPageCubit extends Cubit<EpisodeCommentsPageState> {

  final TvShowsRepository _tvShowsRepository;
  final EpisodeModel _episodeModel;

  EpisodeCommentsPageCubit({
    required TvShowsRepository tvShowsRepository,
    required EpisodeModel episodeModel
  }) : _tvShowsRepository = tvShowsRepository,
       _episodeModel = episodeModel,
       super(EpisodeCommentsPageLoadingState());

  Future<void> fetchEpisodeComments() async {
    emit(EpisodeCommentsPageLoadingState());

    var success = false;
    try {
      await Future.delayed(Duration(milliseconds: 5000));
      final apiResult = await _tvShowsRepository.getWebApiEpisodeComments(episodeId: _episodeModel.id);
      if (apiResult.isStatusCodeOk && apiResult.result != null) {
        success = true;
        emit(EpisodeCommentsPageLoadedState(
          comments: apiResult.result!
        ));
      } else {
        emit(EpisodeCommentsPageErrorState(
          errorMessage: apiResult.error ?? ERROR_GENERIC_SOMETHING_WENT_WRONG
        ));
      }
    } catch (e) {
      emit(EpisodeCommentsPageErrorState(errorMessage: e.toString()));
    }

    if (success) {
      // persist to sembast for offline mode if required
      // butt currently we will not use offline mode comments
      try {
        
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
