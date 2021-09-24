part of 'shows_home_page_cubit.dart';

abstract class ShowsHomePageBaseState extends Equatable {
  const ShowsHomePageBaseState();

  @override
  List<Object> get props => [];
}

class ShowsHomePageLoadingState extends ShowsHomePageBaseState {}


class ShowsHomePageLoadedState extends ShowsHomePageBaseState {

  final List<ShowsModel> showsList;

  const ShowsHomePageLoadedState({
    required this.showsList
  });

  @override
  List<Object> get props => [showsList];

}


class ShowsHomePageShowSnackbarState extends ShowsHomePageBaseState {
  final String message;
  const ShowsHomePageShowSnackbarState({required this.message});

  @override
  List<Object> get props => [message];
}

