import 'dart:developer';
import 'package:dio/dio.dart';

sealed class BaseResponse<T> {}

class SuccessResponse<T> extends BaseResponse<T> {
  final T? data;

   SuccessResponse({this.data});
}

class FailedResponse<T> extends BaseResponse<T> {
  FailedResponse({this.error, this.msg}) {
    msg = msg ?? extractErrorMessage(error);
  }

  final Object? error;
  String? msg;
}


String extractErrorMessage(Object? e) {
  log("extract error msg");
  log("error type is ${e.runtimeType}");

  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case DioExceptionType.receiveTimeout:
        return "Server took too long to respond";
      case DioExceptionType.badResponse:
        return e.response?.data["message"] ?? "Server error";
      default:
        return e.message ?? "Network error";
    }
  }
  return "Unknown error";
}
