class UserApiModel {
  final String name;
  final String email;
  final String deviceId;
  final String sensorId;
  final String usernameThinger;

  UserApiModel({
    required this.name,
    required this.email,
    required this.deviceId,
    required this.sensorId,
    required this.usernameThinger,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) => UserApiModel(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        deviceId: json['device_id'] ?? '',
        sensorId: json['sensor_id'] ?? '',
        usernameThinger: json['username_thinger'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'device_id': deviceId,
        'sensor_id': sensorId,
        'username_thinger': usernameThinger,
      };
}
