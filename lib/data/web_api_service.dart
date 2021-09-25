import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_client.dart';

class WebApiService {

  WebApiService._privateConstructor();

  static final WebApiService _instance = WebApiService._privateConstructor();

  static WebApiService get instance => _instance;

  static const webApiDevBaseUrl = "https://api.infinum.academy";
  static const webApiBaseUrlProd = "https://api.infinum.academy";
  static final webApiBaseUrl = kReleaseMode ? webApiBaseUrlProd : webApiDevBaseUrl;

  factory WebApiService() {
    return _instance;
  }
  

  Future<Response> userLogin({
    required String email, 
    required String password
  }) async {
    final dio = await DioClient().getDio();
    // final deviceUserFriendlyCodeEncoded = Uri.encodeComponent(deviceUserFriendlyCode);
    // final url = "${webApiBaseUrl}users";
    final url = "$webApiBaseUrl/api/users/sessions";
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
    // final deviceUserFriendlyCodeEncoded = Uri.encodeComponent(deviceUserFriendlyCode);
    // final url = "${webApiBaseUrl}users";
    final url = "$webApiBaseUrl/api/shows";
    debugPrint("WebApi request url: $url");
    final response = await dio.get(url);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }


 

}