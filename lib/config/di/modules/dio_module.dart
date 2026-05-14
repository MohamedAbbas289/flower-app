import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flower_app/config/auth/auth_interceptor.dart';
import 'package:flower_app/config/cache/smart_cache_interceptor.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    SmartCacheInterceptor smartCacheInterceptor,
    DioCacheInterceptor dioCacheInterceptor,
  ) {
    final dio = Dio(
      BaseOptions(
        contentType: 'application/json',
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(smartCacheInterceptor);
    dio.interceptors.add(dioCacheInterceptor);
    dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return dio;
  }
}

