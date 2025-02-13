import 'package:intl/intl.dart';

class FormatUtil {
  static String formatDate(String date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(DateTime.parse(date));
  }

  static String formatPhone(String phone) {
    if (phone.length == 11) {
      return phone.replaceAllMapped(
          RegExp(r'(\d{2})(\d{5})(\d{4})'),
          (match) => '(${match[1]}) ${match[2]}-${match[3]}');
    } else if (phone.length == 10) {
      return phone.replaceAllMapped(
          RegExp(r'(\d{2})(\d{4})(\d{4})'),
          (match) => '(${match[1]}) ${match[2]}-${match[3]}');
    }
    return phone;
  }
}
