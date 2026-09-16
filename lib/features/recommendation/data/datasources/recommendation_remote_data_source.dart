import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/sensor_data_model.dart';
import '../models/tanaman_model.dart';

abstract class RecommendationRemoteDataSource {
  Future<SensorDataModel> fetchSensorData({
    required String userName,
    required String deviceId,
    required String sensorId,
    required String accessToken,
  });

  Future<List<String>> getCropRecommendation({
    required String suhu,
    required String kelembabanUdara,
    required String kelembabanTanah,
    required String ph,
  });

  Future<TanamanModel?> getPlantDetails(String plantName);

  Future<void> savePredictionLog({
    required String email,
    required String suhu,
    required String kelembabanUdara,
    required String kelembabanTanah,
    required String ph,
    required String recommendation,
  });
}

class RecommendationRemoteDataSourceImpl implements RecommendationRemoteDataSource {
  final http.Client client;

  RecommendationRemoteDataSourceImpl({required this.client});

  @override
  Future<SensorDataModel> fetchSensorData({
    required String userName,
    required String deviceId,
    required String sensorId,
    required String accessToken,
  }) async {
    try {
      final url = Uri.parse(
        ApiConstants.thingerResourceUrl(
          userName: userName,
          deviceId: deviceId,
          sensorId: sensorId,
        ),
      );

      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final String rawData = responseBody['all'] ?? '';
        return SensorDataModel.fromThingerRaw(rawData);
      } else {
        throw ServerException('Gagal mengambil data sensor Thinger: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getCropRecommendation({
    required String suhu,
    required String kelembabanUdara,
    required String kelembabanTanah,
    required String ph,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.mlPredictUrl);
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "suhu": suhu.isNotEmpty ? suhu : "30",
          "kelembaban_udara": kelembabanUdara.isNotEmpty ? kelembabanUdara : "0.61",
          "kelembaban_tanah": kelembabanTanah,
          "ph": ph,
        }),
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> rawList = responseBody['rekomendasi_tanaman'] ?? [];
        return rawList.map((e) => e.toString()).toList();
      } else {
        final detail = responseBody['detail'] ?? response.body;
        throw ServerException('Gagal mendapatkan rekomendasi: $detail');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TanamanModel?> getPlantDetails(String plantName) async {
    try {
      final url = Uri.parse(ApiConstants.meepLabTanamansEndpoint);
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": plantName}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is List && responseBody.isNotEmpty) {
          return TanamanModel.fromJson(responseBody[0]);
        }
        return null;
      } else {
        throw ServerException('Gagal mengambil informasi tanaman: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> savePredictionLog({
    required String email,
    required String suhu,
    required String kelembabanUdara,
    required String kelembabanTanah,
    required String ph,
    required String recommendation,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.meepLabLogActivityEndpoint);
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "date": DateTime.now().toIso8601String(),
          "pH": ph,
          "kelembabanUdara": kelembabanUdara,
          "kelembabanTanah": kelembabanTanah,
          "suhu": suhu,
          "recommendation": recommendation,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Gagal menyimpan log riwayat');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
