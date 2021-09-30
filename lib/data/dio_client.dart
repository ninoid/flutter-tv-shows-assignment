
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

    final isInternetAvailable = await Utils.isInternetAvailable();
    if (!isInternetAvailable) {
      throw NoInternetException();
    }

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (shouldIncludeAuthorizationHeader) {
          final sp = await SharedPreferences.getInstance();
          final token = sp.getString(WEB_API_AUTH_TOKEN_SHARED_PREFS_KEY) ?? "";
          final langCode = sp.getString("langCode") ?? "en";
          options.headers = {
            "Authorization": token,
            "Lang": langCode,
          };
        }
        handler.next(options);
        
      }, onError: (error, handler) async {
         handler.next(error);
        // final response = error.response;
        // if (response != null) {
        //   if (response.statusCode == 401) {
        //     // unauthorized
        //     RootApp.instance.signOut();
        //   }
        // } else {
        //   handler.next(error);
        // }
      }));
    return dio;
  }
  
}
