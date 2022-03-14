import 'package:timezone/timezone.dart' as tz;

class DateTimeFunctions {
    static DateTime? parseDateTime(String? input, tz.Location location) {
    if (input == null || input.isEmpty) {
      return null;
    } else {
      var utc = DateTime.parse(input);
      var utcTz = tz.TZDateTime.utc(utc.year, utc.month, utc.day, utc.hour, utc.minute, utc.second);
      var dateAtLocation = tz.TZDateTime.from(utcTz, location);
      return DateTime(dateAtLocation.year, dateAtLocation.month, dateAtLocation.day, dateAtLocation.hour, dateAtLocation.minute, dateAtLocation.second);
    }
  }
}