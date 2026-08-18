enum Environment { dev, prod, staging }

class AppEnvSettings {
  static Environment _environment = Environment.dev;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static bool get isDev => _environment == Environment.dev;

  static bool get isProd => _environment == Environment.prod;

  static bool get isStaging => _environment == Environment.staging;
}
