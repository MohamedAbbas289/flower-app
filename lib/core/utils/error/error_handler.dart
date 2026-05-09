import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/app_strings.dart';

class ErrorHandler {
  static String handle(Object exception) {
    /// Dio errors (API / network layer)
    if (exception is DioException) {
      return _handleDioError(exception);
    }

    /// Socket errors (no internet)
    if (exception is SocketException) {
      return AppStrings.noInternetConnection;
    }

    /// Format / parsing errors (JSON issues)
    if (exception is FormatException) {
      return AppStrings.dataParsingError;
    }

    /// Any other type of error
    return AppStrings.somethingWentWrong;
  }

  static String _handleDioError(DioException exception) {
    // Backend custom error message
    final data = exception.response?.data;

    if (data is Map &&
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

  static DioException normalizeDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] != null && data['message'] == null) {
      final normalizedData = {ApiParam.message: data['error'].toString()};
      final normalizedResponse = Response<Map<String, dynamic>>(
        requestOptions: e.requestOptions,
        data: normalizedData,
        statusCode: e.response?.statusCode,
        statusMessage: e.response?.statusMessage,
        headers: e.response?.headers,
      );
      return DioException(
        requestOptions: e.requestOptions,
        response: normalizedResponse,
        type: e.type,
        error: e.error,
        message: e.message,
        stackTrace: e.stackTrace,
      );
    }
    return e;
  }
}
