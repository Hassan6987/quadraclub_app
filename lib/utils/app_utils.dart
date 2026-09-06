import 'package:intl/intl.dart';

class AppUtils {
  static String getFormattedDateWithSlash(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String getFormattedDateWithSlashNullable(DateTime? date) {
    if (date == null) {
      return "";
    }
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String getFormattedDateWithDashNullable(DateTime? date) {
    if (date == null) {
      return "";
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
