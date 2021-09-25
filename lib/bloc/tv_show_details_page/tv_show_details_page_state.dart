part of 'tv_show_details_page_cubit.dart';

abstract class TvShowDetailsPageBaseState extends Equatable {
  const TvShowDetailsPageBaseState();

  @override
  List<Object?> get props => [];
}

class TvShowDetailsPageLoadingState extends TvShowDetailsPageBaseState { }

class TvShowDetailsPageErrorState extends TvShowDetailsPageBaseState {

  final String errorMessage;

  TvShowDetailsPageErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [
    errorMessage
  ];
  
}


class TvShowDetailsPageLoadedState extends TvShowDetailsPageBaseState {

  final TvShowDetailsModel tvShowDetailsModel;
  final List<EpisodeModel> showEpisodes;
  
  TvShowDetailsPageLoadedState({
    required this.tvShowDetailsModel,
    required this.showEpisodes,
  });

  @override
  List<Object?> get props => [
    tvShowDetailsModel,
    showEpisodes
  ];
  
}
