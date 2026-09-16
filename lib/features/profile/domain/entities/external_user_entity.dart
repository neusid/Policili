import 'package:equatable/equatable.dart';

class ExternalUserEntity extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String deviceId;
  final String sensorId;
  final String usernameThinger;

  const ExternalUserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.deviceId,
    required this.sensorId,
    required this.usernameThinger,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        deviceId,
        sensorId,
        usernameThinger,
      ];
}
