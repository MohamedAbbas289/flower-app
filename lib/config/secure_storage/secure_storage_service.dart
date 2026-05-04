import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/values/secure_storage_keys.dart';
import 'local_storage_exception.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService(this._secureStorage);


  Future<void> writeToken(String token) async {
    try {
      if (token.isEmpty) {
        debugPrint(' writeToken called with empty token');
      }

      await _secureStorage.write(
        key: SecureStorageKeys.token,
        value: token,
      );
    } catch (e, s) {
      throw LocalStorageException(
        'Failed to write token',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<String> readToken() async {
    try {
      final token = await _secureStorage.read(
        key: SecureStorageKeys.token,
      );

      if (token == null) {
        debugPrint(' Token not found in secure storage');
        throw LocalStorageException('Token not found');
      }

      return token;
    } on LocalStorageException {
      rethrow;
    } catch (e, s) {
      throw LocalStorageException(
        'Failed to read token',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(
        key: SecureStorageKeys.token,
      );
    } catch (e, s) {
      throw LocalStorageException(
        'Failed to delete token',
        error: e,
        stackTrace: s,
      );
    }
  }


  Future<Map<String, String>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final email = prefs.getString('email');
      final password = prefs.getString('password');

      if (email == null || password == null) {
        debugPrint(' User data contains null values');
      }

      return {
        'email': email ?? '',
        'password': password ?? '',
      };
    } catch (e, s) {
      throw LocalStorageException(
        'Failed to get user data',
        error: e,
        stackTrace: s,
      );
    }
  }
}