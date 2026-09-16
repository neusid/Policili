enum Environment { development, staging, production }

class AppConfig {
  final String appName;
  final Environment environment;
  final String apiBaseUrl;

  const AppConfig({
    required this.appName,
    required this.environment,
    required this.apiBaseUrl,
  });

  static late AppConfig current;

  static void initialize({
    String appName = 'Policili',
    Environment environment = Environment.production,
    String apiBaseUrl = 'https://www.meep-lab.cloud',
  }) {
    current = AppConfig(
      appName: appName,
      environment: environment,
      apiBaseUrl: apiBaseUrl,
    );
  }
}
