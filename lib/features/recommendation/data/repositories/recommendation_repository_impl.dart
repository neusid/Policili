import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/recommendation_result_entity.dart';
import '../../domain/entities/sensor_data_entity.dart';
import '../../domain/entities/tanaman_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_local_data_source.dart';
import '../datasources/recommendation_remote_data_source.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource remoteDataSource;
  final RecommendationLocalDataSource localDataSource;

  // Cache in-memory untuk menyimpan log prediksi sesi ini agar langsung muncul di Riwayat
  static final List<Map<String, dynamic>> sessionPredictionLogs = [];

  RecommendationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, SensorDataEntity>> fetchSensorData() async {
    // Data sensor dummy realistis tanpa hit IoT Thinger.io
    return const Right(SensorDataEntity(
      suhu: "27.5 °C",
      humidity: "76 %",
      soilMoisture: "68 %",
      ph: "6.5",
    ));
  }

  @override
  Future<Either<Failure, List<String>>> getCropRecommendation(
    SensorDataEntity sensorData,
  ) async {
    // Rekomendasi tanaman dummy tanpa hit Hugging Face
    return const Right([
      'Cabai Rawit',
      'Cabai Merah Keriting',
      'Tomat Ceri',
    ]);
  }

  @override
  Future<Either<Failure, TanamanEntity?>> getPlantDetails(String plantName) async {
    // Detail tanaman dummy tanpa hit MEEP Lab API
    return const Right(TanamanEntity(
      idTanaman: 1,
      name: "Cabai Rawit (Capsicum frutescens)",
      kelebihan:
          "Cabai rawit sangat cocok untuk kondisi tanah dan iklim saat ini. Tanaman ini memiliki daya adaptasi tinggi terhadap kelembaban 60-80% dan suhu 25-30°C. Manfaat: Kaya antioksidan capsaicin, vitamin C, memperkuat imunitas tubuh, dan memiliki nilai jual pasar yang sangat tinggi.",
      url: "", // Menggunakan aset lokal mascot.png secara offline
    ));
  }

  @override
  Future<Either<Failure, void>> savePredictionLog({
    required String email,
    required SensorDataEntity sensorData,
    required String recommendation,
  }) async {
    sessionPredictionLogs.insert(0, {
      'email': email.isNotEmpty ? email : 'user@policili.com',
      'suhu': sensorData.suhu,
      'kelembabanUdara': sensorData.humidity,
      'kelembabanTanah': sensorData.soilMoisture,
      'ph': sensorData.ph,
      'recommendation': recommendation,
      'date': DateTime.now().toString(),
    });
    return const Right(null);
  }

  @override
  Future<Either<Failure, RecommendationResultEntity>> generateFullRecommendation(
    String email,
  ) async {
    // Langsung buat hasil rekomendasi lengkap secara offline
    const sensorData = SensorDataEntity(
      suhu: "27.5 °C",
      humidity: "76 %",
      soilMoisture: "68 %",
      ph: "6.5",
    );

    const plantDetails = TanamanEntity(
      idTanaman: 1,
      name: "Cabai Rawit (Capsicum frutescens)",
      kelebihan:
          "Cabai rawit sangat cocok untuk kondisi tanah dan iklim saat ini. Tanaman ini memiliki daya adaptasi tinggi terhadap kelembaban 60-80% dan suhu 25-30°C. Manfaat: Kaya antioksidan capsaicin, vitamin C, memperkuat imunitas tubuh, dan memiliki nilai jual pasar yang sangat tinggi.",
      url: "",
    );

    const primaryCrop = "Cabai Rawit";
    const alternativeCrops = ["Cabai Merah Keriting", "Tomat Ceri"];

    await savePredictionLog(
      email: email.isNotEmpty ? email : "user@policili.com",
      sensorData: sensorData,
      recommendation: primaryCrop,
    );

    return const Right(RecommendationResultEntity(
      sensorData: sensorData,
      plantDetails: plantDetails,
      primaryCropName: primaryCrop,
      alternativeCrops: alternativeCrops,
    ));
  }
}
