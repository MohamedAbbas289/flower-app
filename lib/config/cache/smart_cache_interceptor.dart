import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flower_app/core/values/endpoints.dart';

class SmartCacheInterceptor extends Interceptor {
  final CacheOptions categoriesOptions;
  final CacheOptions productsOptions;
  final CacheOptions homeOptions;

  SmartCacheInterceptor({
    required this.categoriesOptions,
    required this.productsOptions,
    required this.homeOptions,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() != 'GET') {
      handler.next(options);
      return;
    }

    final path = options.uri.path;

    if (path.contains(_categoriesSegment)) {
      options.extra.addAll(categoriesOptions.toExtra());
    } else if (path.contains(_productsSegment)) {
      options.extra.addAll(productsOptions.toExtra());
    } else if (path.contains(_bestSellerSegment) ||
        path.contains(_occasionsSegment)) {
      options.extra.addAll(homeOptions.toExtra());
    }

    handler.next(options);
  }

  static final _categoriesSegment = Uri.parse(Endpoints.getCategories).path;
  static final _productsSegment = Uri.parse(Endpoints.getProducts).path;
  static final _bestSellerSegment = Uri.parse(Endpoints.getBestSeller).path;
  static final _occasionsSegment = Uri.parse(Endpoints.getOccasions).path;
}
