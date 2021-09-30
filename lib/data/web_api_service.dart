import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:tv_shows/core/app_config.dart';
import 'models/add_new_episode_web_api_request_model.dart';

import 'dio_client.dart';

class WebApiService {

  WebApiService._privateConstructor();

  static final WebApiService instance = WebApiService._privateConstructor();

  factory WebApiService() {
    return instance;
  }

  
  static final webApiBaseUrl = kReleaseMode ? WEB_API_BASE_URL_PROD : WEB_API_BASE_URL_DEV;

  

  Future<Response> userLogin({
    required String email, 
    required String password
  }) async {
    final dio = await DioClient().getDio(shouldIncludeAuthorizationHeader: false);
    final url = "/api/users/sessions";
    final data = {
      "email": email,
      "password": password
    };
    debugPrint("WebApi request url: $url");
    final response = await dio.post(url, data: data);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }

  Future<Response> getShows() async {
    final dio = await DioClient().getDio();
    final url = "/api/shows";
    debugPrint("WebApi request url: $url");
    final response = await dio.get(url);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }

  Future<Response> getShowDetails({required String showId}) async {
    final dio = await DioClient().getDio();
    final showIdUrlEncoded = Uri.encodeComponent(showId);
    final url = "/api/shows/$showIdUrlEncoded";
    debugPrint("WebApi request url: $url");
    final response = await dio.get(url);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }

  Future<Response> getShowEpisodes({required String showId}) async {
    final dio = await DioClient().getDio();
    final showIdUrlEncoded = Uri.encodeComponent(showId);
    final url = "/api/shows/$showIdUrlEncoded/episodes";
    debugPrint("WebApi request url: $url");
    final response = await dio.get(url);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }

  Future<Response> getEpisodeDetails({required String episodeId}) async {
    final dio = await DioClient().getDio();
    final episodeIdUrlEncoded = Uri.encodeComponent(episodeId);
    final url = "/api/episodes/$episodeIdUrlEncoded";
    debugPrint("WebApi request url: $url");
    final response = await dio.get(url);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }


  Future<Response> getEpisodeComments({required String episodeId}) async {
    final dio = await DioClient().getDio();
    final episodeIdUrlEncoded = Uri.encodeComponent(episodeId);
    final url = "/api/episodes/$episodeIdUrlEncoded/comments";
    debugPrint("WebApi request url: $url");
    final response = await dio.get(url);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }


  Future<Response> postEpisodeComment({required String episodeId, required String commentText}) async {
    final dio = await DioClient().getDio();
    final url = "/api/comments/";
    debugPrint("WebApi request url: $url");
    final data = {
      "episodeId": episodeId,
      "text": commentText
    };
    debugPrint("WebApi request data: ${data.toString()}");
    final response = await dio.post(url, data: data);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }

  Future<Response> uploadMedia({required File file}) async {
    final dio = await DioClient().getDio(
      contentType: "multipart/form-data"
    );
    final url = "/api/media/";
    debugPrint("WebApi request url: $url");
    final fileName = basename(file.path);
    final multipartFile = await MultipartFile.fromFile(file.path, filename: fileName);
    final formData = FormData();
    formData.files.add(MapEntry("file", multipartFile));
    debugPrint("WebApi request data: ${formData.files.toString()}");
    final response = await dio.post(url, data: formData);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }

  Future<Response> addNewEpisode({required AddNewEpisodeWebApiRequestModel addEpisodeModel}) async {
    final dio = await DioClient().getDio();
    final url = "/api/episodes/";
    debugPrint("WebApi request url: $url");
    final data = addEpisodeModel.toMap();
    debugPrint("WebApi request data: ${data.toString()}");
    final response = await dio.post(url, data: data);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }


 

}