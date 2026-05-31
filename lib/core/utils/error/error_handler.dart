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

    if (data is Map<String, dynamic>) {
      final error = data[ApiParam.error];
      final message = data[ApiParam.message];

      if (error is String && error.isNotEmpty) {
        return error;
      }

      if (message is String && message.isNotEmpty) {
        return message;
      }
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
        return AppStrings.requestCanceled;

      case DioExceptionType.connectionError:
        return AppStrings.noInternetConnection;

      case DioExceptionType.badResponse:
        return _handleStatusCode(exception);

      case DioExceptionType.unknown:
        return AppStrings.unexpectedErrorOccurred;
    }
  }

  static String _handleStatusCode(DioException exception) {
    final code = exception.response?.statusCode;

    switch (code) {
      case 400:
        return AppStrings.badRequest;

      case 401:
        return AppStrings.unauthorized;

      case 403:
        return AppStrings.forbidden;

      case 404:
        return AppStrings.notFound;

      case 500:
        return AppStrings.internalServerError;

      default:
        return AppStrings.serverErrorOccurred;
    }
  }
}