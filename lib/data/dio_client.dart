
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    // _dio.options.validateStatus = (statusCode) {
    //   return true;
    // };
  }

  Future<Dio> getDio() async {
    final sp = await SharedPreferences.getInstance();
    final langCode = sp.getString("langCode") ?? "en";
    _dio.options.headers = {
      "Lang": langCode,
    };
    return _dio;
  }
  
}
