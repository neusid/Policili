import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/external_user_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveSensorData(ExternalUserModel user);

  Future<ExternalUserModel?> getSensorData();

  Future<void> saveTokens({
    required String accessToken,
    required String? refreshToken,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> getSavedPassword();

  Future<String?> getSavedEmail();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  ProfileLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> saveSensorData(ExternalUserModel user) async {
    try {
      final jsonString = jsonEncode(user.toSensorMap());
      await sharedPreferences.setString(AppConstants.keyDataSensor, jsonString);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<ExternalUserModel?> getSensorData() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.keyDataSensor);
      if (jsonString == null) return null;
      final map = jsonDecode(jsonString);
      return ExternalUserModel(
        name: map['name'] ?? '',
        email: '',
        deviceId: map['deviceId'] ?? '',
        sensorId: map['sensorId'] ?? '',
        usernameThinger: map['userName'] ?? '',
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String? refreshToken,
  }) async {
    try {
      await secureStorage.write(
        key: AppConstants.keyAccessToken,
        value: accessToken,
      );
      if (refreshToken != null) {
        await secureStorage.write(
          key: AppConstants.keyRefreshToken,
          value: refreshToken,
        );
      }
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
  Future<String?> getSavedPassword() async {
    try {
      return await secureStorage.read(key: AppConstants.keyPassword);
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
