
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_shows/data/web_api_service.dart';

import '../core/app_config.dart';
import '../core/exceptions/no_internet_exception.dart';
import '../helpers/utils.dart';


class DioClient {
  
  static final DioClient _singleton = DioClient._internal();

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal();


  Future<Dio> getDio({
    bool shouldIncludeAuthorizationHeader = true,
    String contentType = Headers.jsonContentType,
    int connectTimeout = 30000
  }) async {

    final dio = Dio();
    dio.options.baseUrl = WebApiService.webApiBaseUrl;
    dio.options.contentType = contentType;
    dio.options.connectTimeout = connectTimeout;

    // final isInternetAvailable = await Utils.isInternetAvailable();
    // if (!isInternetAvailable) {
    //   throw NoInternetException();
    // }

    if (shouldIncludeAuthorizationHeader) {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString(WEB_API_AUTH_TOKEN_SHARED_PREFS_KEY) ?? "";
      final langCode = sp.getString("langCode") ?? "en";
      dio.options.headers = {
        "Authorization": token,
        "Lang": langCode,
      };
    }
    return dio;
  }
  
}
