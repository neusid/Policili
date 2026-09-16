import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/external_user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ExternalUserModel> getUserProfile(String email);

  Future<String> updateUserProfile(ExternalUserModel user);

  Future<Map<String, dynamic>> getThingerToken({
    required String username,
    required String password,
  });

  Future<Map<String, dynamic>> refreshThingerToken(String refreshToken);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<ExternalUserModel> getUserProfile(String email) async {
    try {
      final url = Uri.parse('${ApiConstants.meepLabGetUserEndpoint}?email=$email');
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ExternalUserModel.fromJson(data);
      } else {
        throw ServerException('Gagal mengambil data profil: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateUserProfile(ExternalUserModel user) async {
    try {
      final url = Uri.parse(ApiConstants.meepLabChangeProfileEndpoint);
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw ServerException('Gagal memperbarui profil: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getThingerToken({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.thingerTokenUrl);
      final response = await client.post(
        url,
        body: {
          'grant_type': 'password',
          'username': username,
          'password': password,
        },
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 && responseBody.containsKey('access_token')) {
        return responseBody;
      } else {
        throw ServerException(responseBody['error'] ?? 'Gagal mendapatkan token Thinger');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> refreshThingerToken(String refreshToken) async {
    try {
      final url = Uri.parse(ApiConstants.thingerTokenUrl);
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException('Gagal memperbarui token Thinger');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
