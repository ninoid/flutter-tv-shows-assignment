import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/tv_shows_model.dart';
import '../../data/repository/tv_shows_repository.dart';

part 'tv_shows_home_page_state.dart';

class TvShowsHomePageCubit extends Cubit<TvShowsHomePageBaseState> {

  final TvShowsRepository _tvShowsRepository;

  TvShowsHomePageCubit({
    required TvShowsRepository tvShowsRepository
  }) 
    : _tvShowsRepository = tvShowsRepository, 
      super(TvShowsHomePageLoadingState());


  Future<void> loadShows() async {
    emit(TvShowsHomePageLoadingState());

    final apiResult = await _tvShowsRepository.getWebApiShows(); 

    emit(TvShowsHomePageLoadedState(
      showsList: apiResult.result ?? []
    ));

  }
}
