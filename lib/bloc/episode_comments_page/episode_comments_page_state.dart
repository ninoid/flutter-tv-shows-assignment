part of 'episode_comments_page_cubit.dart';

abstract class EpisodeCommentsPageState extends Equatable {
  const EpisodeCommentsPageState();

  @override
  List<Object> get props => [];
}

class EpisodeCommentsPageLoadingState extends EpisodeCommentsPageState {}

class EpisodeCommentsPageLoadedState extends EpisodeCommentsPageState {

  final List<EpisodeCommentModel> comments;
  final bool postingNewCommentFlag;

  EpisodeCommentsPageLoadedState({
    required this.comments,
    this.postingNewCommentFlag = false,
  });

  @override
  List<Object> get props => [comments, postingNewCommentFlag];
}
