import 'package:dio/dio.dart';
import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final AuthManager _authManager;

  AuthInterceptor(this._authManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requiresAuth = options.extra[ApiParam.requiresAuth] ?? true;

    if (requiresAuth) {
      final token = _authManager.token;

      if (token != null && token.isNotEmpty) {
        options.headers[ApiParam.authorization] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      await _authManager.logout();
    }

    handler.next(err);
  }
}
