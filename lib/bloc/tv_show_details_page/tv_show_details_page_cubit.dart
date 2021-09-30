import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../core/app_config.dart';
import '../../data/models/tv_shows_model.dart';

import '../../data/models/episode_model.dart';
import '../../data/models/tv_show_details_model.dart';
import '../../data/models/web_api_result.dart';
import '../../data/repository/tv_shows_repository.dart';

part 'tv_show_details_page_state.dart';

class TvShowDetailsPageCubit extends Cubit<TvShowDetailsPageBaseState> {

  final TvShowsRepository _tvShowsRepository;
  final TvShowModel _tvShowModel;
  
  TvShowDetailsPageCubit({
    required TvShowsRepository tvShowsRepository,
    required TvShowModel tvShowModel,
  }) :  _tvShowsRepository = tvShowsRepository,
        _tvShowModel = tvShowModel,
        super(TvShowDetailsPageLoadingState());


  TvShowModel get tvShowModel => _tvShowModel;



  Future<void> loadShowDetails({
    bool restoreFromCacheIfWebApiFails = false, 
    bool simulateDelay = false
  }) async {

    emit(TvShowDetailsPageLoadingState());

    try {
      // simulate delay to show loader state
      await Future.delayed(Duration(milliseconds: simulateDelay ? 1000 : 0));
      
      // run 2 futures at same moment and await them both
      final webApiRequestFutures = await Future.wait([
         _tvShowsRepository.getWebApiShowDetails(showId: _tvShowModel.id),
        _tvShowsRepository.getWebApiShowEpisodes(showId: _tvShowModel.id)
      ]);

      final apiResultShowDetails = webApiRequestFutures.first as  WebApiResult<TvShowDetailsModel?>;
      final apiResultShowEpisodes = webApiRequestFutures.last as  WebApiResult<List<EpisodeModel>?>;

      // we expect that all responses are successful
      if (apiResultShowDetails.isStatusCodeOk && 
          apiResultShowDetails.result != null &&
          apiResultShowEpisodes.isStatusCodeOk &&
          apiResultShowEpisodes.result != null) {

          emit(TvShowDetailsPageLoadedState(
            tvShowDetailsModel: apiResultShowDetails.result!,
            showEpisodes: apiResultShowEpisodes.result!
          ));

      } else {
        // or show error view with error message and tap to retry option
        final errorMsg = apiResultShowDetails.error ?? apiResultShowEpisodes.error ?? ERROR_GENERIC_SOMETHING_WENT_WRONG;
        emit(TvShowDetailsPageErrorState(errorMessage: errorMsg));
      }
      
    } catch (e) {
      debugPrint(e.toString());
      emit(TvShowDetailsPageErrorState(errorMessage: e.toString()));
    }

    if (state is TvShowDetailsPageLoadedState) {
      
    }
    
    
  }



}
