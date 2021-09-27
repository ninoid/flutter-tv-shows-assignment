
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_shows/core/exceptions/no_internet_exception.dart';
import 'package:tv_shows/helpers/utils.dart';


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

  Future<Dio> getDio() async {
    final isInternetAvailable = await Utils.isInternetAvailable();
    if (!isInternetAvailable) {
      throw NoInternetException();
    }
    final sp = await SharedPreferences.getInstance();
    final langCode = sp.getString("langCode") ?? "en";
    _dio.options.headers = {
      "Lang": langCode,
    };
    return _dio;
  }
  
}
