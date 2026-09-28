import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../recommendation/data/repositories/recommendation_repository_impl.dart';
import '../../domain/entities/history_predict_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<HistoryPredictEntity>>> getPredictionHistory(
    String email,
  ) async {
    final now = DateTime.now();
    final userEmail = email.isNotEmpty ? email : 'user@policili.com';

    final List<HistoryPredictEntity> defaultHistory = [
      HistoryPredictEntity(
        id: 1,
        email: userEmail,
        pH: "6.5",
        kelembabanUdara: "76 %",
        kelembabanTanah: "68 %",
        suhu: "27.5 °C",
        recommendation: "Cabai Rawit",
        date: now.subtract(const Duration(minutes: 15)).toString(),
      ),
      HistoryPredictEntity(
        id: 2,
        email: userEmail,
        pH: "6.6",
        kelembabanUdara: "72 %",
        kelembabanTanah: "65 %",
        suhu: "28.0 °C",
        recommendation: "Cabai Merah Keriting",
        date: now.subtract(const Duration(days: 1, hours: 2)).toString(),
      ),
      HistoryPredictEntity(
        id: 3,
        email: userEmail,
        pH: "6.4",
        kelembabanUdara: "78 %",
        kelembabanTanah: "70 %",
        suhu: "26.8 °C",
        recommendation: "Tomat Ceri",
        date: now.subtract(const Duration(days: 2, hours: 5)).toString(),
      ),
      HistoryPredictEntity(
        id: 4,
        email: userEmail,
        pH: "6.8",
        kelembabanUdara: "69 %",
        kelembabanTanah: "60 %",
        suhu: "29.1 °C",
        recommendation: "Paprika Hijau",
        date: now.subtract(const Duration(days: 3, hours: 8)).toString(),
      ),
    ];

    // Ambil log prediksi yang baru saja dibuat di sesi ini
    final sessionLogs = RecommendationRepositoryImpl.sessionPredictionLogs;
    final List<HistoryPredictEntity> sessionEntities = [];
    for (int i = 0; i < sessionLogs.length; i++) {
      final log = sessionLogs[i];
      sessionEntities.add(HistoryPredictEntity(
        id: 100 + i,
        email: log['email'] ?? userEmail,
        pH: log['ph'] ?? '6.5',
        kelembabanUdara: log['kelembabanUdara'] ?? '76 %',
        kelembabanTanah: log['kelembabanTanah'] ?? '68 %',
        suhu: log['suhu'] ?? '27.5 °C',
        recommendation: log['recommendation'] ?? 'Cabai Rawit',
        date: log['date'] ?? now.toString(),
      ));
    }

    return Right([...sessionEntities, ...defaultHistory]);
  }
}

