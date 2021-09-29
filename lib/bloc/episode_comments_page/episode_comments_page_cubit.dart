import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../core/app_config.dart';
import '../../data/models/episode_comment_model.dart';
import '../../data/models/episode_model.dart';
import '../../data/repository/tv_shows_repository.dart';
import '../../main.dart';

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


  String _commentText = "";

  void commentTextChanged(String newValue) {
    _commentText = newValue;
    _validateCommentTextAndUpdateState();
  }

  void _validateCommentTextAndUpdateState() {
    final isValid = _commentText.trim().isNotEmpty;
    final currentState = state as EpisodeCommentsPageLoadedState;
    emit(currentState.copyWith(
      isCommentTextValid: isValid,
    ));
  }


  Future<void> fetchEpisodeComments() async {

    emit(EpisodeCommentsPageLoadingState());

    try {
      // Simulate delay to show skeleton loader effect
      await Future.delayed(Duration(milliseconds: 3000));

      final apiResult = await _tvShowsRepository.getWebApiEpisodeComments(
        episodeId: _episodeModel.id
      );
      if (apiResult.isStatusCodeOk && apiResult.result != null) {
        emit(EpisodeCommentsPageLoadedState(
          comments: apiResult.result!,
        ));
      } else {
        emit(EpisodeCommentsPageErrorState(
          errorMessage: apiResult.error ?? ERROR_GENERIC_SOMETHING_WENT_WRONG
        ));
      }
    } catch (e) {
      emit(EpisodeCommentsPageErrorState(errorMessage: e.toString()));
    }

    // check if successfully loaded from web api
    if (state is EpisodeCommentsPageLoadedState) {
      // persist to sembast for offline mode if required
      // butt currently we will not use offline mode comments
      try {
        
      } catch (e) {
        debugPrint(e.toString());
      }
    }

  }


  Future<void> postEpisodeComment() async {

    var currentState = state as EpisodeCommentsPageLoadedState;
    currentState = currentState.copyWith(postingNewCommentFlag: true);
    emit(currentState);

    try {

      // Simulate web api delay
      await Future.delayed(Duration(milliseconds: 2000));

      final apiResult = await _tvShowsRepository.postWebApiEpisodeComment(
        episodeId: _episodeModel.id,
        commentText: _commentText
      );

      if (apiResult.result != null && apiResult.dioResponse?.statusCode == 201) {
        final newCommentsList = [...currentState.comments, apiResult.result!];
        _commentText = "";
        currentState = currentState.copyWith(
          comments: newCommentsList,
          postingNewCommentFlag: false,
          isCommentTextValid: false
        );
        emit(currentState);
        emit(EpisodeCommentsPagePostSuccessfulState());
        emit(currentState); // revert to loaded state but not rebuid ui (buildWhen condition)
        
      } else {
        final errorMsg = apiResult.error ?? ERROR_GENERIC_SOMETHING_WENT_WRONG;
        RootApp.instance.showSkackbar(message: errorMsg);
        emit(currentState.copyWith(postingNewCommentFlag: false));
      }

    } catch (e) {
      debugPrint(e.toString());
      RootApp.instance.showSkackbar(message: e.toString());
      emit(currentState.copyWith(postingNewCommentFlag: false));
    }

  }
}
