import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_client.dart';

class WebApiService {

  WebApiService._privateConstructor();

  static final WebApiService _instance = WebApiService._privateConstructor();

  static WebApiService get instance => _instance;

  factory WebApiService() {
    return _instance;
  }
  

  Future<Response> getDeviceGuidForDeviceUserFriendlyCode(String deviceUserFriendlyCode) async {
    final dio = await DioClient().getDio();
    final deviceUserFriendlyCodeEncoded = Uri.encodeComponent(deviceUserFriendlyCode);
    final url = "${"API_URL"}api/DeviceToken/$deviceUserFriendlyCodeEncoded";
    debugPrint("WebApi request url: $url");
    final response = await dio.get(url);
    debugPrint("WebApi response data: ${response.data?.toString() ?? ""}");
    return response;
  }


 

}