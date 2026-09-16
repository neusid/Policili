# 🌶️ Policili (Policili Apps)

<p align="center">
  <img src="assets/img/Logo.png" alt="Policili Logo" width="160" />
</p>

<p align="center">
  <strong>Smart Agriculture & AI-Powered Crop Recommendation Mobile Application</strong><br>
  <em>"Meet Your New AI Companion — Talk to Doctor Polichili"</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/BLoC-02569B?style=for-the-badge&logoColor=white" alt="BLoC" />
  <img src="https://img.shields.io/badge/Clean%20Architecture-4CAF50?style=for-the-badge&logoColor=white" alt="Clean Architecture" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Thinger.io-00A98F?style=for-the-badge&logoColor=white" alt="Thinger.io" />
  <img src="https://img.shields.io/badge/Hugging%20Face-FFD21E?style=for-the-badge&logo=huggingface&logoColor=black" alt="Hugging Face" />
</p>

---

## 📖 Tentang Policili

**Policili** adalah aplikasi mobile cerdas berbasis **Flutter** yang dirancang untuk mendukung sektor pertanian presisi (*smart agriculture*). Aplikasi ini mengintegrasikan perangkat **IoT (Internet of Things)** dengan model **Machine Learning (AI)** untuk menganalisis kondisi lingkungan dan tanah secara *real-time*, kemudian memberikan rekomendasi tanaman yang paling optimal untuk dibudidayakan.

Dengan asisten cerdas **Doctor Polichili**, petani, peneliti, maupun pecinta tanaman rumahan dapat dengan mudah mengetahui tanaman apa yang cocok ditanam berdasarkan data sensor akurat tanpa perlu menebak-nebak.

---

## ✨ Fitur Utama

- 🔐 **Autentikasi & Akun Pengguna**
  - Registrasi akun dan login menggunakan **Firebase Authentication**.
  - Fitur *Remember Me* untuk kemudahan akses sesi login.
  - Sinkronisasi profil pengguna dengan backend MEEP Lab.

- 📡 **Integrasi IoT Real-Time (Thinger.io)**
  - Mengambil data sensor secara langsung melalui API platform **Thinger.io**.
  - Pemantauan 4 parameter lingkungan krusial:
    - 🌡️ **Suhu Udara (Temperature)**
    - 💧 **Kelembaban Udara (Air Humidity)**
    - 🪴 **Kelembaban Tanah (Soil Moisture)**
    - ⚗️ **Tingkat Keasaman Tanah (Soil pH)**

- 🤖 **Rekomendasi Tanaman Berbasis AI (Machine Learning)**
  - Memanfaatkan model klasifikasi **Random Forest v2** yang di-deploy di Hugging Face Space.
  - Menghasilkan rekomendasi tanaman utama serta opsi alternatif berdasarkan parameter tanah dan lingkungan.

- 🌿 **Informasi & Manfaat Tanaman**
  - Menampilkan deskripsi, kelebihan/manfaat, serta gambar dari tanaman yang direkomendasikan yang bersumber dari API katalog tanaman.

- 📜 **Riwayat Prediksi (History & Log Activity)**
  - Menyimpan catatan setiap analisis yang dilakukan ke cloud.
  - Memungkinkan pengguna meninjau kembali kondisi sensor dan hasil rekomendasi pada waktu tertentu.

- ⚙️ **Pengaturan Konfigurasi Perangkat**
  - Kemudahan mengatur konfigurasi *Device ID*, *Sensor ID*, serta akun Thinger.io langsung dari antarmuka profil aplikasi.

---

## 🏗️ Arsitektur Sistem

Aplikasi Policili dibangun dengan menerapkan prinsip **Clean Architecture** (Uncle Bob) dan pola manajemen status **BLoC (Business Logic Component)**. Struktur ini memisahkan tanggung jawab kode secara modular (*Separation of Concerns*), independen dari framework eksternal, mudah diuji (*testable*), dan mudah dirawat (*maintainable*).

### 1. Diagram Layer Clean Architecture & BLoC

```mermaid
flowchart TD
    subgraph PresentationLayer ["Layer Presentation (UI & BLoC)"]
        UI["Widgets & Pages<br/>(HomePage, GeneratePage, SignInPage, dll.)"]
        Bloc["BLoC (State Management)<br/>(AuthBloc, RecommendationBloc, ProfileBloc, HistoryBloc)"]
        UI -->|Dispatch Events| Bloc
        Bloc -->|Emit States| UI
    end

    subgraph DomainLayer ["Layer Domain (Murni Dart - Aturan Bisnis)"]
        UC["Use Cases<br/>(SignIn, GenerateRecommendation, UpdateProfile, dll.)"]
        RepoContract["Repository Interfaces (Contracts)"]
        Entities["Business Entities<br/>(User, SensorData, Tanaman, History)"]
        Bloc -->|Panggil| UC
        UC -->|Bergantung pada Kontrak| RepoContract
        UC -.->|Menggunakan| Entities
    end

    subgraph DataLayer ["Layer Data (Akses Sumber Data & Model)"]
        RepoImpl["Repository Implementations"]
        Models["Data Models / DTO (from/to JSON)"]
        RemoteDS["Remote Data Sources"]
        LocalDS["Local Data Sources"]

        RepoImpl -.->|Implements| RepoContract
        RepoImpl --> RemoteDS
        RepoImpl --> LocalDS
        RepoImpl -.-> Models
    end

    subgraph ExternalServices ["External Services & Hardware"]
        Thinger["Thinger.io IoT Server<br/>(Data Real-time: Suhu, Kelembaban, pH)"]
        HFApi["Hugging Face AI Space<br/>(Model Random Forest v2)"]
        FirebaseAuth["Firebase Authentication<br/>(User Auth & Session)"]
        MeepLabApi["MEEP Lab Cloud API<br/>(User, Tanamans, Log Activity)"]
        LocalCache["Storage Lokal<br/>(SharedPreferences & FlutterSecureStorage)"]

        RemoteDS -->|HTTP REST| Thinger
        RemoteDS -->|HTTP REST| HFApi
        RemoteDS -->|Firebase SDK| FirebaseAuth
        RemoteDS -->|HTTP REST| MeepLabApi
        LocalDS -->|Key-Value Store| LocalCache
    end
```

### 2. Diagram Alir Data Rekomendasi (End-to-End)

Diagram berikut menjelaskan siklus alur data saat pengguna menekan tombol **"Generate now"** untuk mendapatkan rekomendasi tanaman:

```mermaid
sequenceDiagram
    autonumber
    actor User as Pengguna
    participant UI as Flutter App
    participant Bloc as RecommendationBloc
    participant UseCase as GenerateFullRecommendationUseCase
    participant Thinger as Thinger.io IoT
    participant HF as Hugging Face AI
    participant MeepLab as MEEP Lab API

    User->>UI: Klik "Generate now"
    UI->>Bloc: Dispatch GenerateRecommendationSubmittedEvent
    Bloc->>UseCase: Eksekusi Use Case
    UseCase->>Thinger: GET Nilai Sensor (Suhu, Kelembaban Tanah, Kelembaban Udara, pH)
    Thinger-->>UseCase: Return Nilai Sensor Real-time
    UseCase->>HF: POST Data Sensor ke Endpoint Prediksi
    HF-->>UseCase: Return Rekomendasi Tanaman (Utama & Alternatif)
    UseCase->>MeepLab: POST Query Detail & Manfaat Tanaman
    MeepLab-->>UseCase: Return Data & Gambar Tanaman
    UseCase->>MeepLab: POST Log Aktivitas Prediksi
    MeepLab-->>UseCase: Status Log Tersimpan
    UseCase-->>Bloc: Return RecommendationResultEntity
    Bloc-->>UI: Emit RecommendationLoaded
    UI-->>User: Tampilkan Halaman Rekomendasi Tanaman & Parameter Sensor
```

### 3. Penjelasan Layer Arsitektur

1. **Layer Presentation (`lib/features/[fitur]/presentation/`)**
   - **BLoC**: Bertanggung jawab menerima *Event* dari antarmuka pengguna, memproses logika melalui *Use Case*, dan memancarkan (*emit*) *State* baru ke UI.
   - **Pages & Widgets**: Komponen UI yang mengonsumsi state secara reaktif melalui `BlocBuilder`, `BlocListener`, atau `BlocConsumer`. Bebas dari logika pemanggilan API langsung.

2. **Layer Domain (`lib/features/[fitur]/domain/`)**
   - **Entities**: Objek data bisnis inti yang bersih dari anotasi JSON atau dependensi framework.
   - **Repository Contracts**: *Interface* abstrak yang mendefinisikan kontrak operasi data tanpa mengetahui cara implementasinya.
   - **Use Cases**: Komponen yang merepresentasikan satu tindakan bisnis spesifik (misalnya: `FetchSensorDataUseCase`, `SignInUseCase`).

3. **Layer Data (`lib/features/[fitur]/data/`)**
   - **Models**: Representasi data Transfer Object (DTO) yang memiliki kemampuan serialisasi JSON (`fromJson` dan `toJson`).
   - **Data Sources**:
     - *Remote Data Source*: Mengelola interaksi jaringan ke REST API (MEEP Lab, Thinger.io, Hugging Face, Firebase).
     - *Local Data Source*: Mengelola penyimpanan token aman dan cache konfigurasi perangkat.
   - **Repositories Implementation**: Mengimplementasikan kontrak interface dari Domain layer dengan mengorkestrasi *data sources* dan menangani konversi exception menjadi *Failure*.

4. **Core & App Configuration (`lib/core/` & `lib/app/`)**
   - **`core/di/`**: Inisialisasi *Dependency Injection* menggunakan **GetIt** (`sl`) untuk menghubungkan implementasi ke abstraksi secara *loose coupling*.
   - **`core/errors/`**: Standar penanganan kegagalan (*Failure*) dan *Exception* menggunakan pendekatan fungsional `Either<Failure, T>`.
   - **`app/config/routes/`**: Manajemen navigasi terpusat berbasis *Named Routes* dan *Route Generator*.

---

## 🛠️ Teknologi & Dependensi

| Kategori | Teknologi / Pustaka | Deskripsi |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (SDK: `>=3.4.4 <4.0.0`) | Framework UI lintas platform |
| **Bahasa** | [Dart](https://dart.dev) | Bahasa pemrograman utama |
| **State Management** | [flutter_bloc](https://pub.dev/packages/flutter_bloc) | State management BLoC yang terprediksi & reaktif |
| **Dependency Injection** | [get_it](https://pub.dev/packages/get_it) | Service locator untuk dependency injection |
| **Functional Error Handling**| [dartz](https://pub.dev/packages/dartz) & [equatable](https://pub.dev/packages/equatable) | Either pattern (Failure / Success) & value equality |
| **Autentikasi** | [Firebase Core](https://pub.dev/packages/firebase_core) & [Auth](https://pub.dev/packages/firebase_auth) | Layanan login & keamanan pengguna |
| **Komunikasi Data** | [http](https://pub.dev/packages/http) | HTTP client untuk REST API |
| **Penyimpanan Lokal** | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage), [shared_preferences](https://pub.dev/packages/shared_preferences) | Penyimpanan kredensial token dan konfigurasi lokal |
| **Desain & Animasi** | `mesh_gradient`, `animated_splash_screen`, `curved_navigation_bar`, `flutter_speed_dial`, `google_fonts`, `flutter_screenutil` | Tampilan UI responsif, animasi mesh gradient, dan custom font Inter/Roboto |

---

## 📂 Struktur Direktori (Clean Architecture)

```text
lib/
├── app/
│   └── config/                    # Konfigurasi global aplikasi
│       ├── app_config.dart        # Environment config (dev/staging/prod)
│       ├── routes/                # Definisi routing & navigasi aplikasi
│       │   ├── app_routes.dart
│       │   └── route_generator.dart
│       └── app.dart               # Root widget (PoliciliApp) & MaterialApp
│
├── core/                          # Komponen reusable lintas fitur
│   ├── constants/                 # Konstanta global (API URL, keys, dll)
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── di/                        # Dependency Injection (GetIt setup)
│   │   └── injection_container.dart
│   ├── errors/                    # Definisi Failure & Exception
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── theme/                     # ThemeData, warna, typography
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── utils/                     # Helper, date formatter, snackbar
│   │   ├── date_formatter.dart
│   │   └── ui_helpers.dart
│   └── widgets/                   # Widget reusable (InputField, Loading, dll)
│       ├── input_field.dart
│       ├── input_field_short.dart
│       └── loading_overlay.dart
│
├── features/                      # Modul fitur yang berdiri sendiri
│   ├── auth/                      # Fitur Autentikasi (Login, Register, Remember Me)
│   │   ├── data/                  # Data Layer (Remote/Local DataSources, Models, RepoImpl)
│   │   ├── domain/                # Domain Layer (UserEntity, AuthRepository, UseCases)
│   │   └── presentation/          # Presentation Layer (AuthBloc, SignInPage, SignUpPage, SplashPage)
│   │
│   ├── profile/                   # Fitur Profil & Konfigurasi IoT (Thinger.io)
│   │   ├── data/                  # Data Layer (Remote/Local DataSources, ExternalUserModel, RepoImpl)
│   │   ├── domain/                # Domain Layer (ExternalUserEntity, ProfileRepository, UseCases)
│   │   └── presentation/          # Presentation Layer (ProfileBloc, ChangeProfilePage)
│   │
│   ├── recommendation/            # Fitur Rekomendasi Tanaman & Monitoring Sensor IoT
│   │   ├── data/                  # Data Layer (SensorDataModel, TanamanModel, RepoImpl)
│   │   ├── domain/                # Domain Layer (SensorDataEntity, TanamanEntity, UseCases)
│   │   └── presentation/          # Presentation Layer (RecommendationBloc, HomePage, GeneratePage, CardDevice)
│   │
│   └── history/                   # Fitur Riwayat Prediksi
│       ├── data/                  # Data Layer (HistoryPredictModel, RemoteDataSource, RepoImpl)
│       ├── domain/                # Domain Layer (HistoryPredictEntity, HistoryRepository, UseCase)
│       └── presentation/          # Presentation Layer (HistoryBloc, HistoryPage, CardHistory)
│
├── firebase_options.dart          # Konfigurasi Firebase CLI
└── main.dart                      # Entry point aplikasi
```

---

## 🚀 Memulai (Getting Started)

### Prasyarat
Sebelum menjalankan proyek ini, pastikan komputer Anda telah terpasang:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.4.4 atau yang lebih baru)
- [Dart SDK](https://dart.dev/get-dart)
- Editor yang didukung: VS Code atau Android Studio dengan plugin Flutter & Dart
- Emulator Android / Simulator iOS atau perangkat fisik yang terhubung

### Langkah Instalasi

1. **Clone repositori**:
   ```bash
   git clone https://github.com/neusid/Policili.git
   cd Policili
   ```

2. **Pasang dependensi**:
   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase**:
   - Pastikan berkas konfigurasi Firebase (`google-services.json` untuk Android atau `GoogleService-Info.plist` untuk iOS) telah tersedia atau gunakan FlutterFire CLI:
     ```bash
     flutterfire configure
     ```

4. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

---

## 📱 Alur Penggunaan

1. **Registrasi & Masuk**: Buat akun baru atau masuk dengan akun terdaftar.
2. **Koneksi Perangkat IoT**: Pada menu *Change Profile*, isi konfigurasi perangkat Thinger.io Anda (*Device ID*, *Sensor ID*, dan *Username Thinger*).
3. **Generate Rekomendasi**:
   - Klik tombol **"Generate now"** di dashboard beranda.
   - Aplikasi akan membaca data sensor terkini dari Thinger.io.
   - Model AI akan menganalisis data tanah dan cuaca untuk memprediksi tanaman terbaik beserta alternatifnya.
4. **Lihat Riwayat**: Buka menu *History Predict* untuk melihat riwayat rekomendasi dan data sensor sebelumnya.

---

## 📄 Lisensi & Hak Cipta

Dikelola dan dikembangkan oleh tim pengembang **Policili** (MEEP Lab). Seluruh hak cipta dilindungi undang-undang.
