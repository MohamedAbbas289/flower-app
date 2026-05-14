import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flower_app/core/values/endpoints.dart';

class SmartCacheInterceptor extends Interceptor {
  final CacheOptions _categoriesOptions;
  final CacheOptions _productsOptions;

  SmartCacheInterceptor({
    required CacheOptions categoriesOptions,
    required CacheOptions productsOptions,
  }) : _categoriesOptions = categoriesOptions,
       _productsOptions = productsOptions;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() != 'GET') {
      handler.next(options);
      return;
    }

    final path = options.uri.path;

    if (path.contains(_categoriesSegment)) {
      options.extra.addAll(_categoriesOptions.toExtra());
    } else if (path.contains(_productsSegment)) {
      options.extra.addAll(_productsOptions.toExtra());
    }

    handler.next(options);
  }

  static final _categoriesSegment = Uri.parse(Endpoints.getCategories).path;
  static final _productsSegment = Uri.parse(Endpoints.getProducts).path;
}
