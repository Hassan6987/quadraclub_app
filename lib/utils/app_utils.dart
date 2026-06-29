import 'package:intl/intl.dart';

class AppUtils {
  static String getFormattedDateWithSlash(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
