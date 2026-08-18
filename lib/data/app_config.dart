import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quadraclub_app/data/app_env_settings.dart';

enum Environment { debug, staging, production }

class AppConfig {
  static Environment get environment {
    if (kDebugMode) return Environment.debug;
    if (AppEnvSettings.isProd) return Environment.production;
    if (AppEnvSettings.isStaging) return Environment.staging;
    return Environment.debug;
  }

  static String get baseUrl {
    switch (environment) {
      case Environment.production:
        return '${dotenv.env['BASE_URL_PROD']}';
      case Environment.staging:
        return '${dotenv.env['BASE_URL_STAGING']}';
      case Environment.debug:
        return '${dotenv.env['BASE_URL_DEBUG']}';
    }
  }
}
