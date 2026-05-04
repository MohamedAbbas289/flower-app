import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthManager {
  final SecureStorageService _storage;

  String? _token;
  String? _userId;

  AuthManager(this._storage);

  String? get token => _token;

  String? get userId => _userId;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<void> init() async {
    final rememberMe = await _storage.readRememberMe();

    if (!rememberMe) {
      _token = null;
      _userId = null;
      return;
    }

    final savedToken = await _storage.readToken();
    final savedUserId = await _storage.readUserId();

    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
    }

    if (savedUserId != null && savedUserId.isNotEmpty) {
      _userId = savedUserId;
    }
  }

  Future<void> setAuthData({
    required String token,
    required bool rememberMe,
    String? userId,
  }) async {
    if (token.isEmpty) {
      throw Exception(AppStrings.tokenEmpty);
    }

    _token = token;
    _userId = userId;

    await _storage.writeRememberMe(rememberMe);

    if (rememberMe) {
      await _storage.writeToken(token);

      if (userId != null) {
        await _storage.writeUserId(userId);
      }
    } else {
      await _storage.deleteToken();
      await _storage.deleteUserId();
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;

    await _storage.clearAll();
  }

  Future<bool> shouldAutoLogin() async {
    final rememberMe = await _storage.readRememberMe();
    if (!rememberMe) return false;

    final token = await _storage.readToken();
    return token != null && token.isNotEmpty;
  }
}
