class ApiConstants {
  static const String meepLabBaseUrl = 'https://www.meep-lab.cloud';
  static const String meepLabUserEndpoint = '$meepLabBaseUrl/api/users';
  static const String meepLabGetUserEndpoint = '$meepLabBaseUrl/api/users/getUser';
  static const String meepLabChangeProfileEndpoint = 'https://meep-lab.cloud/api/users/change_profile';
  static const String meepLabTanamansEndpoint = '$meepLabBaseUrl/api/tanamans';
  static const String meepLabLogActivityEndpoint = 'https://meep-lab.cloud/api/users/log_activity';
  static const String meepLabGetLogEndpoint = 'https://meep-lab.cloud/api/users/getLog';
  static const String meepLabImageBaseUrl = '$meepLabBaseUrl/images';

  static const String thingerTokenUrl = 'https://api.thinger.io/oauth/token';
  static String thingerResourceUrl({
    required String userName,
    required String deviceId,
    required String sensorId,
  }) =>
      'https://api.thinger.io/v3/users/$userName/devices/$deviceId/resources/$sensorId';

  static const String mlPredictUrl = 'https://neusisco-ModelRFv2.hf.space/predict';
}
