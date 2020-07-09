import 'package:intl/intl.dart';

class ConvertTimeToLocal {
  getCurrentLocalTime(dateUtc) {
    return DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(dateUtc, true)
        .toLocal()
        .toString();
  }
}