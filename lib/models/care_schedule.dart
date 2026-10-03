import 'package:intl/intl.dart';
import 'care_routine.dart';

/// One calendar-day policy used by Today, Care, Calendar and completion history.
class CareSchedule {
  static DateTime day(DateTime value) =>
      DateTime(value.year, value.month, value.day);
  static String dayKey(DateTime value) =>
      DateFormat('yyyy-MM-dd').format(value);

  static DateTime? parseDate(String value) {
    for (final pattern in [
      'yyyy-MM-dd',
      'MMM dd, yyyy',
      'MMM d, yyyy',
      'MMM yyyy'
    ]) {
      try {
        return DateFormat(pattern).parseStrict(value);
      } on FormatException {
        // Older records used human-readable dates; preserve their meaning.
      }
    }
    return null;
  }

  static bool isDue(CareRoutine routine, DateTime date) {
    final start = parseDate(routine.date);
    if (start == null) return false;
    final selected = day(date);
    if (selected.isBefore(day(start))) return false;
    switch (routine.recurrence.toLowerCase()) {
      case 'daily':
      case 'twice daily':
        return true;
      case 'weekdays':
        return selected.weekday <= 5;
      case 'every 2 weeks':
        return DateTime.utc(selected.year, selected.month, selected.day)
                    .difference(
                        DateTime.utc(start.year, start.month, start.day))
                    .inDays %
                14 ==
            0;
      case 'every 30 days':
        return DateTime.utc(selected.year, selected.month, selected.day)
                    .difference(
                        DateTime.utc(start.year, start.month, start.day))
                    .inDays %
                30 ==
            0;
      case 'weekly':
        return selected.weekday == start.weekday;
      case 'monthly':
        final lastDay = DateTime(selected.year, selected.month + 1, 0).day;
        return selected.day == (start.day > lastDay ? lastDay : start.day);
      default:
        return selected == day(start);
    }
  }

  static int minutes(String value) {
    final match =
        RegExp(r'^(\d{1,2}):(\d{2})(?:\s*(AM|PM))?$', caseSensitive: false)
            .firstMatch(value.trim());
    if (match == null) return 24 * 60;
    var hour = int.parse(match[1]!);
    final minute = int.parse(match[2]!);
    final period = match[3]?.toUpperCase();
    if (minute > 59 ||
        hour > (period == null ? 23 : 12) ||
        (period != null && hour < 1)) return 24 * 60;
    if (period != null) hour = hour % 12 + (period == 'PM' ? 12 : 0);
    return hour * 60 + minute;
  }
}
