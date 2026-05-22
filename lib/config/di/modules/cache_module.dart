import 'dart:io';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flower_app/config/cache/smart_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@module
abstract class CacheModule {
  @preResolve
  @lazySingleton
  Future<CacheStore> cacheStore() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return HiveCacheStore(
        '${dir.path}${Platform.pathSeparator}dio_cache',
        hiveBoxName: 'flower_app_cache',
      );
    } catch (_) {
      return MemCacheStore();
    }
  }

  @lazySingleton
  SmartCacheInterceptor smartCacheInterceptor(CacheStore store) =>
      SmartCacheInterceptor(
        categoriesOptions: CacheOptions(
          store: store,
          policy: CachePolicy.request,
          maxStale: const Duration(days: 1),
          hitCacheOnErrorExcept: [401, 403],
        ),
        productsOptions: CacheOptions(
          store: store,
          policy: CachePolicy.refreshForceCache,
          maxStale: const Duration(days: 1),
          hitCacheOnErrorExcept: [401, 403],
        ),
        homeOptions: CacheOptions(
          store: store,
          policy: CachePolicy.request,
          maxStale: const Duration(days: 1),
          hitCacheOnErrorExcept: [401, 403],
        ),
      );

  @lazySingleton
  DioCacheInterceptor dioCacheInterceptor(CacheStore store) =>
      DioCacheInterceptor(
        options: CacheOptions(store: store, policy: CachePolicy.noCache),
      );
}
