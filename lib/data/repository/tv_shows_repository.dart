import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import '../../core/app_config.dart';

import '../models/add_new_episode_web_api_request_model.dart';
import '../models/episode_comment_model.dart';
import '../models/episode_model.dart';
import '../models/tv_show_details_model.dart';
import '../models/tv_shows_model.dart';
import '../models/upload_media_web_api_response_model.dart';
import '../models/web_api_result.dart';
import '../web_api_service.dart';

abstract class TvShowsRepository {

  // Web Api methods
  Future<WebApiResult<List<TvShowModel>?>> getWebApiTvShows();
  Future<WebApiResult<TvShowDetailsModel>?> getWebApiShowDetails({required String showId});
  Future<WebApiResult<List<EpisodeModel>?>> getWebApiShowEpisodes({required String showId});
  Future<WebApiResult<List<EpisodeCommentModel>?>> getWebApiEpisodeComments({required String episodeId});
  Future<WebApiResult<EpisodeCommentModel?>> postWebApiEpisodeComment({required String episodeId, required String commentText});
  Future<WebApiResult<UploadMediaWebApiResponseModel?>> uploadWebApiMedia({required File file});
  Future<WebApiResult<String?>> addWebApiNewEpisode({required AddNewEpisodeWebApiRequestModel addEpisodeModel});
  
  // Sembast database
  Future<List<TvShowModel>?> getLocalStoreTvShows();
  Future<void> saveTvShowsToLocalStore(List<TvShowModel> tvShows);
  Future<void> deleteAllTvShowsFromLocalStore();
  Future<TvShowDetailsModel?> getLocalStoreTvShowDetailsModel(String tvShowId);
  Future<void> saveTvShowDetailsToLocalStore(TvShowDetailsModel tvShow);
  Future<List<EpisodeModel>?> getLocalStoreTvShowEpisodes(String tvShowId);
  Future<void> saveTvShowEpisodesToLocalStore({required String tvShowId, required List<EpisodeModel> episodes});
  Future<void> deleteAllTvShowDetailsAndEpisodesFromLocalStore();
  Future<List<EpisodeCommentModel>?> getLocalStoreEpisodeComments(String episodeId);
  Future<void> saveEpisodeCommentsToLocalStore({required String episodeId, required List<EpisodeCommentModel> comments});
  Future<void> deleteAllEpisodeCommentsFromLocalStore();
  Future<void> deleteAllLocalStoreCache();
  
}



class TvShowsRepositoryImpl extends TvShowsRepository {

  Database get _sembastDb => GetIt.I.get<Database>();
  final _mainStore = StoreRef.main();
  final _tvShowDetailsStore = StoreRef<String, dynamic>(TV_SHOW_DETAILS_STORE_NAME);
  final _episodeCommentsStore = StoreRef<String, dynamic>(EPISODE_COMMENTS_STORE_NAME);
  

  @override
  Future<WebApiResult<List<TvShowModel>?>> getWebApiTvShows() async {
    try {
      final dioResponse = await WebApiService.instance.getShows();
      final WebApiResult<List<TvShowModel>?> apiResult = WebApiResult.fromDioResponse(dioResponse); 
      final responseData = dioResponse.data["data"];
      if (responseData is List) {
        apiResult.result = responseData.map((element) => TvShowModel.fromMap(element)).toList();
      }
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }
    
  }

  @override
  Future<WebApiResult<TvShowDetailsModel>?> getWebApiShowDetails({required String showId}) async {
    try {
      final dioResponse = await WebApiService.instance.getShowDetails(showId: showId);
      final WebApiResult<TvShowDetailsModel> apiResult = WebApiResult.fromDioResponse(dioResponse); 
      final responseData = dioResponse.data["data"];
      if (responseData is Map<String, dynamic>) {
        apiResult.result = TvShowDetailsModel.fromMap(responseData);
      }
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }
  }

  @override
  Future<WebApiResult<List<EpisodeModel>?>> getWebApiShowEpisodes({required String showId}) async {
    try {
      final dioResponse = await WebApiService.instance.getShowEpisodes(showId: showId);
      final WebApiResult<List<EpisodeModel>?> apiResult = WebApiResult.fromDioResponse(dioResponse); 
      final responseData = dioResponse.data["data"];
      if (responseData is List) {
        apiResult.result = responseData.map((element) => EpisodeModel.fromMap(element)).toList();
      }
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }
  }

  @override
  Future<WebApiResult<List<EpisodeCommentModel>?>> getWebApiEpisodeComments({required String episodeId}) async {
    try {
      final dioResponse = await WebApiService.instance.getEpisodeComments(episodeId: episodeId);
      final WebApiResult<List<EpisodeCommentModel>?> apiResult = WebApiResult.fromDioResponse(dioResponse); 
      final responseData = dioResponse.data["data"];
      if (responseData is List) {
        apiResult.result = responseData.map((element) => EpisodeCommentModel.fromMap(element)).toList();
      }
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }
  }

  @override
  Future<WebApiResult<EpisodeCommentModel?>> postWebApiEpisodeComment({required String episodeId, required String commentText}) async {
    try {
      final dioResponse = await WebApiService.instance.postEpisodeComment(
        episodeId: episodeId, 
        commentText: commentText
      );
      final WebApiResult<EpisodeCommentModel?> apiResult = WebApiResult.fromDioResponse(dioResponse); 
      final responseData = dioResponse.data["data"];
      if (responseData is Map<String, dynamic>) {
        apiResult.result = EpisodeCommentModel.fromMap(responseData);
      }
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }
  }

  @override
  Future<WebApiResult<String?>> addWebApiNewEpisode({required AddNewEpisodeWebApiRequestModel addEpisodeModel}) async {
    try {
      final dioResponse = await WebApiService.instance.addNewEpisode(
        addEpisodeModel: addEpisodeModel
      );
      final WebApiResult<String?> apiResult = WebApiResult.fromDioResponse(dioResponse); 
      apiResult.result = dioResponse.data["data"]?["showId"] as String?;
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }
  }

  @override
  Future<WebApiResult<UploadMediaWebApiResponseModel?>> uploadWebApiMedia({required File file}) async {
    try {
      final dioResponse = await WebApiService.instance.uploadMedia(file: file);
      final WebApiResult<UploadMediaWebApiResponseModel?> apiResult = WebApiResult.fromDioResponse(dioResponse); 
      final responseData = dioResponse.data["data"];
      if (responseData is Map<String, dynamic>) {
        apiResult.result = UploadMediaWebApiResponseModel.fromMap(responseData);
      }
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }
  }


  // On Unauthenticate/SignOut
  @override
  Future<void> deleteAllLocalStoreCache() async {
    await Future.wait([
      deleteAllTvShowsFromLocalStore(),
      deleteAllTvShowDetailsAndEpisodesFromLocalStore(),
      deleteAllEpisodeCommentsFromLocalStore()
    ]);
  }


  @override
  Future<List<TvShowModel>?> getLocalStoreTvShows() async {
    final data = await _mainStore.record(TV_SHOWS_RECORD_ID).get(_sembastDb);
    if (data is List) {
      return data.map((e) => TvShowModel.fromMap(e)).toList();
    }
    return null;
  }

  @override
  Future<void> saveTvShowsToLocalStore(List<TvShowModel> tvShows) async {
    final data = tvShows.map((e) => e.toMap()).toList();
    await _mainStore.record(TV_SHOWS_RECORD_ID).put(_sembastDb, data);
  }

  @override
  Future<void> deleteAllTvShowsFromLocalStore() async {
    await _mainStore.record(TV_SHOWS_RECORD_ID).delete(_sembastDb);
  }


  String _getTvShowDetailsRecordId({required String tvShowId}) => "show/$tvShowId/details";
  String _getTvShowEpisodesRecordId({required String tvShowId}) => "show/$tvShowId/episodes";


  @override
  Future<TvShowDetailsModel?> getLocalStoreTvShowDetailsModel(String tvShowId) async {
    final recordId = _getTvShowDetailsRecordId(tvShowId: tvShowId);
    final data = await _tvShowDetailsStore.record(recordId).get(_sembastDb);
    if (data is Map<String, dynamic>) {
      return TvShowDetailsModel.fromMap(data);
    } 
    return null;
  }

  @override
  Future<List<EpisodeModel>?> getLocalStoreTvShowEpisodes(String tvShowId) async {
    final recordId = _getTvShowEpisodesRecordId(tvShowId: tvShowId);
    final data = await _tvShowDetailsStore.record(recordId).get(_sembastDb);
    if (data is List) {
      return data.map((e) => EpisodeModel.fromMap(e)).toList();
    } 
    return null;
  }

  @override
  Future<void> saveTvShowDetailsToLocalStore(TvShowDetailsModel tvShow) async {
    final recordId = _getTvShowDetailsRecordId(tvShowId: tvShow.id);
    await _tvShowDetailsStore.record(recordId).put(_sembastDb, tvShow.toMap());
  }

  @override
  Future<void> saveTvShowEpisodesToLocalStore({
    required String tvShowId, 
    required List<EpisodeModel> episodes
  }) async {
    final recordId = _getTvShowEpisodesRecordId(tvShowId: tvShowId);
    final value = episodes.map((e) => e.toMap()).toList();
    await _tvShowDetailsStore.record(recordId).put(_sembastDb, value);
  }

  @override
  Future<void> deleteAllTvShowDetailsAndEpisodesFromLocalStore() async {
    await _tvShowDetailsStore.drop(_sembastDb);
  }


  String _getEpisodeCommentsRecordId({required String episodeId}) => "episode/$episodeId/comments";

  @override
  Future<List<EpisodeCommentModel>?> getLocalStoreEpisodeComments(String episodeId) async {
    final recordId = _getEpisodeCommentsRecordId(episodeId: episodeId);
    final data = await _episodeCommentsStore.record(recordId).get(_sembastDb);
    if (data is List) {
      return data.map((e) => EpisodeCommentModel.fromMap(e)).toList();
    }
    return null;
  }

  @override
  Future<void> saveEpisodeCommentsToLocalStore({
    required String episodeId, 
    required List<EpisodeCommentModel> comments
  }) async {
    final recordId = _getEpisodeCommentsRecordId(episodeId: episodeId);
    final value = comments.map((e) => e.toMap()).toList();
    await _episodeCommentsStore.record(recordId).put(_sembastDb, value);
  }
  

  @override
  Future<void> deleteAllEpisodeCommentsFromLocalStore() async {
    await _episodeCommentsStore.drop(_sembastDb);
  }

  
}