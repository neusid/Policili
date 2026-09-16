# Flutter Clean Architecture & BLoC Standards

Setiap penambahan atau modifikasi kode pada proyek ini harus mengikuti standar Clean Architecture dan pola state management BLoC:

## 1. Struktur Folder
```text
lib/
├── app/
│   └── config/              # app_config.dart, routes/, app.dart
├── core/                    # Komponen lintas fitur
│   ├── constants/           # api_constants.dart, app_constants.dart
│   ├── di/                  # injection_container.dart (GetIt setup)
│   ├── errors/              # failures.dart (Either pattern), exceptions.dart
│   ├── theme/               # app_colors.dart, app_theme.dart
│   ├── utils/               # date_formatter.dart, ui_helpers.dart
│   └── widgets/             # input_field.dart, loading_overlay.dart
└── features/                # Modul fitur mandiri
    └── [feature_name]/
        ├── data/            # datasources/, models/, repositories/
        ├── domain/          # entities/, repositories/, usecases/
        └── presentation/    # bloc/, pages/, widgets/
```

## 2. Aturan Per Layer
- **Domain Layer**: Murni Dart tanpa dependensi framework. Entity wajib meng-extend `Equatable`. Repository interface mengembalikan `Either<Failure, T>` dari `dartz`.
- **Data Layer**: Model meng-extend Entity dan mengimplementasikan `fromJson`/`toJson`. Remote/Local Data Source melempar `Exception`, lalu Repository Implementation menangkapnya dan mengembalikan `Left(Failure)` atau `Right(Data)`.
- **Presentation Layer**: Menggunakan `flutter_bloc`. Event dan State meng-extend `Equatable`. Widget UI mengonsumsi state dengan `BlocBuilder`, `BlocListener`, atau `BlocConsumer`.
- **Dependency Injection**: Seluruh Data Source, Repository, Use Case, dan BLoC didaftarkan ke `sl` (`GetIt`) di `core/di/injection_container.dart`.
- **Cross-Feature Imports**: Gunakan selalu package import (`package:policili_apps/features/...`) untuk impor antar-fitur untuk menghindari kesalahan relative path (`../../../`).
