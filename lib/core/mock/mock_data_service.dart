import '../../features/history/domain/entities/history_predict_entity.dart';
import '../../features/recommendation/domain/entities/sensor_data_entity.dart';
import '../../features/recommendation/domain/entities/tanaman_entity.dart';

/// In-Memory Stateful Mock Data Engine (Sesuai Protokol Bab 6 Master Knowledge)
class MockDataService {
  MockDataService._();
  static final MockDataService instance = MockDataService._();

  // Kredensial & Profil Pengguna Mock
  String userName = "Petani Cerdas Malik";
  String userEmail = "user@policili.com";
  String deviceId = "POLICILI-IOT-01";
  String sensorId = "SOIL-CLIMATE-01";
  String usernameThinger = "policili_user";

  int _step = 0;

  // Telemetri Sensor Dummy Realistis (Berotasi Dinamis)
  SensorDataEntity getNextSensorData() {
    _step++;
    final samples = [
      const SensorDataEntity(
        suhu: "28.4",
        humidity: "72",
        soilMoisture: "65",
        ph: "6.6",
      ),
      const SensorDataEntity(
        suhu: "27.8",
        humidity: "75",
        soilMoisture: "68",
        ph: "6.5",
      ),
      const SensorDataEntity(
        suhu: "29.1",
        humidity: "68",
        soilMoisture: "61",
        ph: "6.7",
      ),
      const SensorDataEntity(
        suhu: "26.9",
        humidity: "78",
        soilMoisture: "70",
        ph: "6.4",
      ),
    ];
    return samples[_step % samples.length];
  }

  // Katalog Detail Tanaman Cabai & Hortikultura
  TanamanEntity getPlantDetailsFor(String plantName) {
    if (plantName.contains('Keriting')) {
      return const TanamanEntity(
        idTanaman: 2,
        name: "Cabai Merah Keriting (Capsicum annuum)",
        kelebihan:
            "Cabai merah keriting memiliki adaptasi optimal pada suhu 26-29°C dan kelembaban tanah 60-70%. Karakteristik rasa pedas tajam, tahan pengangkutan jarak jauh, dan toleran terhadap penyakit layu bakteri.",
        url: "",
      );
    } else if (plantName.contains('Tomat')) {
      return const TanamanEntity(
        idTanaman: 3,
        name: "Tomat Ceri Agrotech (Solanum lycopersicum)",
        kelebihan:
            "Varietas pendamping ideal dengan toleransi pH tanah 6.0 - 6.8. Memiliki masa panen cepat 60-75 hari dengan produktivitas tinggi.",
        url: "",
      );
    }
    return const TanamanEntity(
      idTanaman: 1,
      name: "Cabai Rawit Merah (Capsicum frutescens)",
      kelebihan:
          "Cabai rawit sangat cocok untuk kondisi tanah dan iklim saat ini. Memiliki daya adaptasi tinggi terhadap kelembaban 60-80% dan suhu 25-30°C. Kaya antioksidan capsaicin, vitamin C, serta bernilai ekonomi tinggi di pasaran.",
      url: "",
    );
  }

  // Riwayat Prediksi Stateful Dalam Memori
  final List<HistoryPredictEntity> predictionHistory = [
    HistoryPredictEntity(
      id: 1,
      email: 'user@policili.com',
      pH: "6.6",
      kelembabanUdara: "72",
      kelembabanTanah: "65",
      suhu: "28.4",
      recommendation: "Cabai Rawit Merah",
      date: DateTime.now().subtract(const Duration(minutes: 12)).toString(),
    ),
    HistoryPredictEntity(
      id: 2,
      email: 'user@policili.com',
      pH: "6.5",
      kelembabanUdara: "75",
      kelembabanTanah: "68",
      suhu: "27.8",
      recommendation: "Cabai Merah Keriting",
      date: DateTime.now().subtract(const Duration(hours: 3)).toString(),
    ),
    HistoryPredictEntity(
      id: 3,
      email: 'user@policili.com',
      pH: "6.7",
      kelembabanUdara: "68",
      kelembabanTanah: "61",
      suhu: "29.1",
      recommendation: "Tomat Ceri",
      date: DateTime.now().subtract(const Duration(days: 1, hours: 2)).toString(),
    ),
    HistoryPredictEntity(
      id: 4,
      email: 'user@policili.com',
      pH: "6.4",
      kelembabanUdara: "78",
      kelembabanTanah: "70",
      suhu: "26.9",
      recommendation: "Cabai Rawit Merah",
      date: DateTime.now().subtract(const Duration(days: 2, hours: 5)).toString(),
    ),
  ];

  void addPredictionRecord({
    required String email,
    required SensorDataEntity sensor,
    required String recommendation,
  }) {
    predictionHistory.insert(
      0,
      HistoryPredictEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        email: email.isNotEmpty ? email : userEmail,
        pH: sensor.ph,
        kelembabanUdara: sensor.humidity,
        kelembabanTanah: sensor.soilMoisture,
        suhu: sensor.suhu,
        recommendation: recommendation,
        date: DateTime.now().toString(),
      ),
    );
  }
}
