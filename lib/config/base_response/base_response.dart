import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';

sealed class BaseResponse<T> {}

class SuccessResponse<T> extends BaseResponse<T> {
  SuccessResponse({required this.data});

  T? data;
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
    final data = e.response?.data;

    if (data is Map && data["message"] != null) {
      return data["message"].toString();
    }

    return e.message ?? "Some Thing Went Wrong";
  } else if (e is TimeoutException) {
    return "Connection Time Out";
  } else {
    return "Some Thing Went Wrong";
  }
}
