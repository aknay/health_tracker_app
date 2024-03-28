import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DateTimeHelper {
  static initTimezone() {
    tz.initializeTimeZones();
  }

  static tz.TZDateTime scheduleDaily(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      kDebugMode ? now.hour : time.hour,
      kDebugMode ? now.minute + 1 : time.minute,
      time.second,
    );
    return scheduleDate.isBefore(now) ? scheduleDate.add(const Duration(days: 1)) : scheduleDate;
  }
}
