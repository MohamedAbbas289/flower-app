import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../core/values/secure_storage_keys.dart';
import 'local_storage_exception.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService(this._secureStorage);

  Future<void> writeToken(String token) async {
    try {
      if (token.isEmpty) {
        throw LocalStorageException(AppStrings.tokenEmpty);
      }

      await _secureStorage.write(key: SecureStorageKeys.token, value: token);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.tokenWriteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<String?> readToken() async {
    try {
      return await _secureStorage.read(key: SecureStorageKeys.token);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.tokenReadFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.token);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.tokenDeleteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> writeUserId(String userId) async {
    try {
      if (userId.isEmpty) {
        throw LocalStorageException(AppStrings.userIdEmpty);
      }

      await _secureStorage.write(key: SecureStorageKeys.userId, value: userId);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.userIdWriteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<String?> readUserId() async {
    try {
      return await _secureStorage.read(key: SecureStorageKeys.userId);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.userIdReadFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteUserId() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.userId);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.userIdDeleteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> writeRememberMe(bool value) async {
    try {
      await _secureStorage.write(
        key: SecureStorageKeys.rememberMe,
        value: value.toString(),
      );
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.rememberMeWriteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<bool> readRememberMe() async {
    try {
      final value = await _secureStorage.read(
        key: SecureStorageKeys.rememberMe,
      );

      return value == 'true';
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.rememberMeReadFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteRememberMe() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.rememberMe);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.rememberMeDeleteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> writeNotificationsEnabled(bool value) async {
    await _secureStorage.write(
      key: SecureStorageKeys.notificationsEnabled,
      value: value.toString(),
    );
  }

  Future<bool> readNotificationsEnabled() async {
    final value = await _secureStorage.read(
      key: SecureStorageKeys.notificationsEnabled,
    );
    return value == null ? true : value == 'true';
  }

  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.clearStorageFailed,
        error: e,
        stackTrace: s,
      );
    }
  }
}
