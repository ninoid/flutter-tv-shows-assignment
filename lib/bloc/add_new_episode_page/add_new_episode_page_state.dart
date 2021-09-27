part of 'add_new_episode_page_cubit.dart';

class AddNewEpisodePageState extends Equatable {

  final bool savingNewEpisode;

  const AddNewEpisodePageState({
    this.savingNewEpisode = false
  });

  @override
  List<Object> get props => [
    savingNewEpisode
  ];
}


