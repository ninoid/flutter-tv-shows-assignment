import 'package:tv_shows/data/models/episode_comment_model.dart';

import '../models/episode_model.dart';
import '../models/tv_show_details_model.dart';
import '../models/tv_shows_model.dart';
import '../models/web_api_result.dart';
import '../web_api_service.dart';

abstract class TvShowsRepository {

  Future<WebApiResult<List<TvShowModel>?>> getWebApiShows();
  Future<WebApiResult<TvShowDetailsModel>?> getWebApiShowDetails({required String showId});
  Future<WebApiResult<List<EpisodeModel>?>> getWebApiShowEpisodes({required String showId});
  Future<WebApiResult<List<EpisodeCommentModel>?>> getWebApiEpisodeComments({required String episodeId});
  Future<WebApiResult<EpisodeCommentModel?>> postWebApiEpisodeComment({required String episodeId, required String commentText});

}



class TvShowsRepositoryImpl extends TvShowsRepository {
  
  @override
  Future<WebApiResult<List<TvShowModel>?>> getWebApiShows() async {
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

 
  
}