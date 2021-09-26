import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tv_shows/data/models/api_response.dart';
import 'package:tv_shows/data/models/episode_model.dart';
import 'package:tv_shows/data/models/tv_show_details_model.dart';
import 'package:tv_shows/data/repository/tv_shows_repository.dart';

part 'tv_show_details_page_state.dart';

class TvShowDetailsPageCubit extends Cubit<TvShowDetailsPageBaseState> {

  final TvShowsRepository _tvShowsRepository;
  final String _tvShowId;
  
  TvShowDetailsPageCubit({
    required TvShowsRepository tvShowsRepository,
    required String tvShowId,
  }) :  _tvShowsRepository = tvShowsRepository,
        _tvShowId = tvShowId,
        super(TvShowDetailsPageLoadingState());




  Future<void> loadShowDetails() async {

    emit(TvShowDetailsPageLoadingState());

    try {

      // increase delay to show loader state
      await Future.delayed(Duration(milliseconds: 1000));

      // run 2 futures at same moment and await both
      final webApiRequestFutures = [
        _tvShowsRepository.getWebApiShowDetails(showId: _tvShowId),
        _tvShowsRepository.getWebApiShowEpisodes(showId: _tvShowId)
      ];
      await Future.wait(webApiRequestFutures);

      final apiResultShowDetails = (await webApiRequestFutures.first) as  WebApiResult<TvShowDetailsModel?>;
      final apiResultShowEpisodes = (await webApiRequestFutures.last) as  WebApiResult<List<EpisodeModel>?>;

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
        
        final errorMsg = apiResultShowDetails.error ?? apiResultShowDetails.error ?? "";
        emit(TvShowDetailsPageErrorState(errorMessage: errorMsg));

      }
      
    } catch (e) {
      debugPrint(e.toString());
      emit(TvShowDetailsPageErrorState(errorMessage: e.toString()));
    }
    
    
  }



}
