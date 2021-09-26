part of 'tv_shows_home_page_cubit.dart';

abstract class TvShowsHomePageState extends Equatable {
  const TvShowsHomePageState();

  @override
  List<Object> get props => [];
}

class TvShowsHomePageLoadingState extends TvShowsHomePageState {}


class TvShowsHomePageLoadedState extends TvShowsHomePageState {

  final List<TvShowModel> showsList;

  const TvShowsHomePageLoadedState({
    required this.showsList
  });

  @override
  List<Object> get props => [showsList];

}


