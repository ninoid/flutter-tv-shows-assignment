import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../tv_show_details_page/tv_show_details_page_cubit.dart';
import '../../core/app_config.dart';
import '../../data/models/add_new_episode_web_api_request_model.dart';
import '../../data/models/tv_shows_model.dart';
import '../../data/repository/tv_shows_repository.dart';
import '../../main.dart';

part 'add_new_episode_page_state.dart';

class AddNewEpisodePageCubit extends Cubit<AddNewEpisodePageBaseState> {

  final TvShowsRepository _tvShowsRepository;
  final TvShowDetailsPageCubit _tvShowDetailsPageCubit;
  

  AddNewEpisodePageCubit({
    required TvShowsRepository tvShowsRepository,
    required TvShowDetailsPageCubit tvShowDetailsPageCubit
  }) : _tvShowsRepository = tvShowsRepository,
       _tvShowDetailsPageCubit = tvShowDetailsPageCubit,
       super(AddNewEpisodePageState());

  TvShowModel get _tvShowModel => _tvShowDetailsPageCubit.tvShowModel;
  String get _showId => _tvShowModel.id;


  String _coverImageFilePath = "";
  String _title = "";
  String _description = "";
  String _seasonNumber = "";
  String _episodeNumber = "";


   String get seasonAndEpisodeCombinedString {
    if (int.tryParse(_seasonNumber) != null && int.tryParse(_episodeNumber) != null) {
      return "Season$_seasonNumber, Ep$_episodeNumber";
    }
    return "";
  }


  void _validateUserInputsAndUpdateState() {

    final isValid = _coverImageFilePath.trim().isNotEmpty &&
                    _title.trim().isNotEmpty &&
                    seasonAndEpisodeCombinedString.isNotEmpty &&
                    _description.trim().isNotEmpty;

    emit((state as AddNewEpisodePageState).copyWith(
      addButtonEnabled: isValid,
      pickedSeasonAndEpisodeCombinedString: seasonAndEpisodeCombinedString,
      coverImageFilePath: _coverImageFilePath
    ));
  }


  void setCoverImagePath(String filePath) {
    _coverImageFilePath = filePath;
    _validateUserInputsAndUpdateState();
  }

  void titleTextChanged(String newValue) {
    _title = newValue;
    _validateUserInputsAndUpdateState();
  }

  void descriptionTextChanged(String newValue) {
    _description = newValue;
    _validateUserInputsAndUpdateState();
  }

  void setSeasonAndEpisodeValues({
    required String season, 
    required String episode
  }) {
    _seasonNumber = season;
    _episodeNumber = episode;
    _validateUserInputsAndUpdateState();
  }


  Future<void> addNewEpisodeAction() async {
    emit((state as AddNewEpisodePageState).copyWith(
      postingNewEpisodeToApiFlag: true
    ));
    
    // add some delay for test :)
    await Future.delayed(Duration(milliseconds: 1000));

    bool success = false;
    String? errorMessage;

    try {
      // we will not resize or compress image in this demo... :)
      final uploadImageApiResult = await _tvShowsRepository.uploadWebApiMedia(
        file: File(_coverImageFilePath)
      );
      // validate uplaod image api response and check if mediaId exists
      success = uploadImageApiResult.isStatusCodeOk && 
                uploadImageApiResult.result != null;
      if (success) {
        final addEpisodeModel = AddNewEpisodeWebApiRequestModel(
          showId: _showId, 
          mediaId: uploadImageApiResult.result!.id, 
          title: _title, 
          description: _description, 
          episodeNumber: _episodeNumber, 
          season: _seasonNumber
        );
        final addEpisodeApiResult = await _tvShowsRepository.addWebApiNewEpisode(
          addEpisodeModel: addEpisodeModel
        );
        success = addEpisodeApiResult.isStatusCodeOk && true;
                  (addEpisodeApiResult.result?.trim() ?? "").isNotEmpty; // check if showId is valid
        if (!success) {
          errorMessage = addEpisodeApiResult.error;
        }
      } else {
        errorMessage = uploadImageApiResult.error;
      }
    } catch (e) {
      // debugPrint(e.toString());
      errorMessage = e.toString();
      
    }

    if (success) {
      emit(AddNewEpisodeSuccessState());
      RootApp.instance.showFlushbar(message: "New episode added :)");
      _tvShowDetailsPageCubit.loadShowDetails();
    } else {
      RootApp.instance.showFlushbar(message: errorMessage ?? ERROR_GENERIC_SOMETHING_WENT_WRONG);
      emit((state as AddNewEpisodePageState).copyWith(postingNewEpisodeToApiFlag: false));
    }

  }


}
