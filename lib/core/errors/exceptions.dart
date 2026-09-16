class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Terjadi kesalahan pada server']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Terjadi kesalahan pada cache']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Terjadi kesalahan autentikasi']);
}
