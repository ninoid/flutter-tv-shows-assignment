import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_shows/data/models/episode_comment_model.dart';

part 'episode_comments_page_state.dart';

class EpisodeCommentsPageCubit extends Cubit<EpisodeCommentsPageState> {
  EpisodeCommentsPageCubit() : super(EpisodeCommentsPageLoadingState());
}
