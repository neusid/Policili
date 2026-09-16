import 'package:intl/intl.dart';

class DateFormatter {
  static String formatIndonesianDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy H:m:s', 'id_ID').format(dateTime);
    } catch (_) {
      return dateString;
    }
  }
}
