import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/history_predict_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryPredictModel>> getPredictionHistory(String email);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final http.Client client;

  HistoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<HistoryPredictModel>> getPredictionHistory(String email) async {
    try {
      final url = Uri.parse('${ApiConstants.meepLabGetLogEndpoint}?email=$email');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => HistoryPredictModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        throw ServerException('Gagal mengambil data riwayat: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
