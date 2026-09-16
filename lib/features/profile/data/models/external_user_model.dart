import '../../domain/entities/external_user_entity.dart';

class ExternalUserModel extends ExternalUserEntity {
  const ExternalUserModel({
    super.id,
    required super.name,
    required super.email,
    required super.deviceId,
    required super.sensorId,
    required super.usernameThinger,
  });

  factory ExternalUserModel.fromJson(Map<String, dynamic> json) =>
      ExternalUserModel(
        id: json["id"],
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        deviceId: json["device_id"] ?? json["deviceId"] ?? '',
        sensorId: json["sensor_id"] ?? json["sensorId"] ?? '',
        usernameThinger: json["username_thinger"] ?? json["userName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        "name": name,
        "email": email,
        "device_id": deviceId,
        "sensor_id": sensorId,
        "username_thinger": usernameThinger,
      };

  Map<String, dynamic> toSensorMap() => {
        'name': name,
        'deviceId': deviceId,
        'sensorId': sensorId,
        'userName': usernameThinger,
      };
}
