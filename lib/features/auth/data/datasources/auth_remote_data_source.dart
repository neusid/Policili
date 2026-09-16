import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_api_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String deviceId,
    required String sensorId,
    required String usernameThinger,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth firebaseAuth;
  final http.Client client;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.client,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw const AuthException('Pengguna tidak ditemukan');
      }
      return UserModel.fromFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Gagal masuk akun');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String deviceId,
    required String sensorId,
    required String usernameThinger,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw const AuthException('Gagal membuat akun');
      }

      // Kirim profil ke REST API MEEP Lab
      final userApi = UserApiModel(
        name: name,
        email: email,
        deviceId: deviceId,
        sensorId: sensorId,
        usernameThinger: usernameThinger,
      );

      final url = Uri.parse(ApiConstants.meepLabUserEndpoint);
      await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userApi.toJson()),
      );

      return UserModel.fromFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw const AuthException('Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        throw const AuthException('Email sudah terdaftar');
      } else {
        throw AuthException(e.message ?? 'Pendaftaran gagal');
      }
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }
}
