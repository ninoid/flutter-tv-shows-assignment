part of 'add_new_episode_page_cubit.dart';

class AddNewEpisodePageBaseState extends Equatable {
  const AddNewEpisodePageBaseState();

  @override
  List<Object?> get props => [];
}

// simple listener state to close page on success
class AddNewEpisodeSuccessState extends AddNewEpisodePageBaseState {}

class AddNewEpisodePageState extends AddNewEpisodePageBaseState {

  final bool addButtonEnabled;
  final bool postingNewEpisodeToApiFlag;
  final String? coverImageFilePath;
  final String pickedSeasonAndEpisodeCombinedString;

  const AddNewEpisodePageState({
    this.addButtonEnabled = false,
    this.postingNewEpisodeToApiFlag = false,
    this.coverImageFilePath,
    this.pickedSeasonAndEpisodeCombinedString = ""
  });

  @override
  List<Object?> get props => [
    addButtonEnabled,
    postingNewEpisodeToApiFlag,
    coverImageFilePath,
    pickedSeasonAndEpisodeCombinedString
  ];

  AddNewEpisodePageState copyWith({
    bool? addButtonEnabled,
    bool? postingNewEpisodeToApiFlag,
    String? coverImageFilePath,
    String? pickedSeasonAndEpisodeCombinedString
  }) {
    return AddNewEpisodePageState(
      addButtonEnabled: addButtonEnabled ?? this.addButtonEnabled,
      postingNewEpisodeToApiFlag: postingNewEpisodeToApiFlag ?? this.postingNewEpisodeToApiFlag,
      coverImageFilePath: coverImageFilePath ?? this.coverImageFilePath,
      pickedSeasonAndEpisodeCombinedString: pickedSeasonAndEpisodeCombinedString ?? this.pickedSeasonAndEpisodeCombinedString
    );
  }

}


