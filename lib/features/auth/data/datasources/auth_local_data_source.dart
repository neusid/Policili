import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCredentials({
    required String email,
    required String password,
  });

  Future<Map<String, String?>> getCredentials();

  Future<void> clearCredentials();

  Future<bool> getRememberMe();

  Future<void> setRememberMe(bool value);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await secureStorage.write(key: AppConstants.keyEmail, value: email);
      await secureStorage.write(key: AppConstants.keyPassword, value: password);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    try {
      final email = await secureStorage.read(key: AppConstants.keyEmail);
      final password = await secureStorage.read(key: AppConstants.keyPassword);
      return {
        AppConstants.keyEmail: email,
        AppConstants.keyPassword: password,
      };
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearCredentials() async {
    try {
      await secureStorage.delete(key: AppConstants.keyEmail);
      await secureStorage.delete(key: AppConstants.keyPassword);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<bool> getRememberMe() async {
    try {
      return sharedPreferences.getBool(AppConstants.keyRememberMe) ?? false;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> setRememberMe(bool value) async {
    try {
      await sharedPreferences.setBool(AppConstants.keyRememberMe, value);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
