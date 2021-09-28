
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_shows/core/app_config.dart';
import '../core/exceptions/no_internet_exception.dart';
import '../helpers/utils.dart';


class DioClient {
  
  static final DioClient _singleton = DioClient._internal();

  late Dio _dio;

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    _dio = new Dio();
    _dio.options.followRedirects = false;
    _dio.options.connectTimeout = 30000;
    _dio.options.contentType = "application/json"; // default value
  }

  Future<Dio> getDio({bool shouldIncludeAuthorizationHeader = true}) async {
    final isInternetAvailable = await Utils.isInternetAvailable();
    if (!isInternetAvailable) {
      throw NoInternetException();
    }
    if (shouldIncludeAuthorizationHeader) {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString(WEB_API_AUTH_TOKEN_SHARED_PREFS_KEY) ?? "";
      final langCode = sp.getString("langCode") ?? "en";
      _dio.options.headers = {
        "Authorization": token,
        "Lang": langCode,
      };
    }
    return _dio;
  }
  
}
