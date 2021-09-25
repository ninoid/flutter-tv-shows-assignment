part of 'tv_shows_home_page_cubit.dart';

abstract class TvShowsHomePageBaseState extends Equatable {
  const TvShowsHomePageBaseState();

  @override
  List<Object> get props => [];
}

class TvShowsHomePageLoadingState extends TvShowsHomePageBaseState {}


class TvShowsHomePageLoadedState extends TvShowsHomePageBaseState {

  final List<TvShowModel> showsList;

  const TvShowsHomePageLoadedState({
    required this.showsList
  });

  @override
  List<Object> get props => [showsList];

}


class TvShowsHomePageShowSnackbarState extends TvShowsHomePageBaseState {
  final String message;
  const TvShowsHomePageShowSnackbarState({required this.message});

  @override
  List<Object> get props => [message];
}

