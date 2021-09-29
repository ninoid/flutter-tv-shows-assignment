import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class WebApiResult<T> {

  // Simplify parse common api response fields and other checks scenarios
  // like common api response fields, error messages and similar

  T? result;
  String? error;
  // List<String>? errors;
  Response? dioResponse;


  // bool get isStatusCodeOk => (dioResponse?.statusCode ?? -1) == 200;
  
  bool get isStatusCodeOk {
    final statusCode = (dioResponse?.statusCode ?? -1);
    return [200, 201, 202, 203].any((e) => e == statusCode);
  }

  // bool get hasErrors => errors?.any((errMsg) => errMsg.trim().isNotEmpty) ?? false;
  
  // String? get errorMessage  {
  //   if (hasErrors) {
  //     return errors!.join("\n").trim();
  //   }
  //   return null;
  // }


  WebApiResult.fromDioResponse(Response response) {
    dioResponse = response;
    final responseData = response.data;
    if(responseData is Map<String, dynamic>) {
      error = responseData["error"];
    } else {
      error = "error_invalid_response_data_format";
    }
  }


  WebApiResult.fromError(dynamic e) {
    debugPrint("ApiResponse.fromError(dynamic e): ${e?.toString() ?? ""}");
    // errors = [];
    if (e is DioError) {
      dioResponse = e.response;
      if (e.response?.data is Map<String, dynamic>) {
        final errorMessage = e.response!.data["error"]?.toString().trim() ?? "";
        if (errorMessage.isNotEmpty) {
          error = errorMessage;
        } else {
          error = e.message;
        }
      } else {
        error = e.message;
      }
    } else {
      // exception, error...
      error = e?.toString() ?? "error_generic_something_went_wrong_localized_key";
    } 
  }


}
