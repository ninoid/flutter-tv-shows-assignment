part of 'episode_comments_page_cubit.dart';

abstract class EpisodeCommentsPageState extends Equatable {
  const EpisodeCommentsPageState();

  @override
  List<Object> get props => [];
}

class EpisodeCommentsPageLoadingState extends EpisodeCommentsPageState {}

// Listener state - Clear textfield and scroll to the end of listview
class EpisodeCommentsPagePostSuccessfulState extends EpisodeCommentsPageState {}

class EpisodeCommentsPageLoadedState extends EpisodeCommentsPageState {

  final List<EpisodeCommentModel> comments;
  final bool isCommentTextValid;
  final bool postingNewCommentFlag;

  EpisodeCommentsPageLoadedState({
    required this.comments,
    this.isCommentTextValid = false,
    this.postingNewCommentFlag = false,
  });

  @override
  List<Object> get props => [
    comments, 
    isCommentTextValid,
    postingNewCommentFlag,
  ];

  EpisodeCommentsPageLoadedState copyWith({
    List<EpisodeCommentModel>? comments,
    bool? isCommentTextValid,
    bool? postingNewCommentFlag,
  }) {
    return EpisodeCommentsPageLoadedState(
      comments: comments ?? this.comments,
      isCommentTextValid: isCommentTextValid ?? this.isCommentTextValid,
      postingNewCommentFlag: postingNewCommentFlag ?? this.postingNewCommentFlag,
    );
  }
}

class EpisodeCommentsPageErrorState extends EpisodeCommentsPageState {

  final String errorMessage;

  EpisodeCommentsPageErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
