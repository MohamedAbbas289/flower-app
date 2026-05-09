import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/app_strings.dart';

class ErrorHandler {
  static String handle(Object exception) {
    if (exception is DioException) {
      return _handleDioError(exception);
    }

    if (exception is SocketException) {
      return AppStrings.noInternetConnection;
    }

    if (exception is FormatException) {
      return AppStrings.dataParsingError;
    }

    return AppStrings.somethingWentWrong;
  }

  static String _handleDioError(DioException exception) {
    final data = exception.response?.data;

    if (data is Map<String, dynamic> &&
        data[ApiParam.error] != null &&
        data[ApiParam.error] is String) {
      return data[ApiParam.error];
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return AppStrings.connectionTimeout;

      case DioExceptionType.sendTimeout:
        return AppStrings.requestTimeout;

      case DioExceptionType.receiveTimeout:
        return AppStrings.serverTookTooLongToRespond;

      case DioExceptionType.badCertificate:
        return AppStrings.badCertificate;

      case DioExceptionType.cancel:
        return AppStrings.cancel;

      case DioExceptionType.connectionError:
        return AppStrings.noInternetConnection;

      case DioExceptionType.badResponse:
        return AppStrings.serverErrorOccurred;

      case DioExceptionType.unknown:
        return AppStrings.unexpectedErrorOccurred;
    }
  }
}
