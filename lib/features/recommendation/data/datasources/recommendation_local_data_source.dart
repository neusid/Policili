import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class RecommendationLocalDataSource {
  Future<Map<String, dynamic>?> getSensorConfig();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getSavedEmail();
}

class RecommendationLocalDataSourceImpl implements RecommendationLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  RecommendationLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<Map<String, dynamic>?> getSensorConfig() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.keyDataSensor);
      if (jsonString == null) return null;
      return jsonDecode(jsonString);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(key: AppConstants.keyAccessToken);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: AppConstants.keyRefreshToken);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getSavedEmail() async {
    try {
      return await secureStorage.read(key: AppConstants.keyEmail);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
