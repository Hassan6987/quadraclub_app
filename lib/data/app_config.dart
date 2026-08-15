import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { debug, staging, production }

class AppConfig {
  static Environment get environment {
    if (kDebugMode) return Environment.debug;
    if (kProfileMode) return Environment.staging;
    return Environment.production;
  }

  static String get baseUrl {
    switch (environment) {
      case Environment.production:
        return '${dotenv.env['BASE_URL_DEBUG']}';
      case Environment.staging:
        return 'https://your-prod-url.com';
      case Environment.debug:
        return '${dotenv.env['BASE_URL_DEBUG']}';
    }
  }
}
