import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan pada server']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Terjadi kesalahan pada penyimpanan lokal']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Autentikasi gagal']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet']);
}
