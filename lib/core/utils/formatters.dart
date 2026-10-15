import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String formatDate(
    DateTime? date, {
    String pattern = 'dd MMM yyyy',
    String? locale = 'id_ID',
  }) {
    if (date == null) return '-';
    try {
      return DateFormat(pattern, locale).format(date);
    } catch (_) {
      return DateFormat(pattern).format(date);
    }
  }

  static String formatDateTime(
    DateTime? dateTime, {
    String pattern = 'dd MMM yyyy, HH:mm',
    String? locale = 'id_ID',
  }) {
    if (dateTime == null) return '-';
    try {
      return DateFormat(pattern, locale).format(dateTime);
    } catch (_) {
      return DateFormat(pattern).format(dateTime);
    }
  }

  static String formatTime(
    DateTime? time, {
    String pattern = 'HH:mm',
  }) {
    if (time == null) return '-';
    return DateFormat(pattern).format(time);
  }

  static String formatCurrency(
    num? amount, {
    String symbol = 'Rp ',
    int decimalDigits = 0,
    String? locale = 'id_ID',
  }) {
    if (amount == null) return '${symbol}0';
    try {
      final formatter = NumberFormat.currency(
        locale: locale,
        symbol: symbol,
        decimalDigits: decimalDigits,
      );
      return formatter.format(amount);
    } catch (_) {
      return '$symbol$amount';
    }
  }

  static String formatNumber(
    num? number, {
    String? locale = 'id_ID',
  }) {
    if (number == null) return '0';
    try {
      final formatter = NumberFormat.decimalPattern(locale);
      return formatter.format(number);
    } catch (_) {
      return number.toString();
    }
  }

  static double? parseCurrency(String? formatted) {
    if (formatted == null || formatted.trim().isEmpty) return null;
    final sanitized = formatted.replaceAll(RegExp(r'[^0-9,-]'), '').replaceAll(',', '.');
    return double.tryParse(sanitized);
  }

  static String formatDuration(
    Duration? duration, {
    bool compact = false,
  }) {
    if (duration == null) return '-';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (compact) {
      if (hours > 0) {
        return '${hours}j ${minutes}m';
      }
      return '${minutes}m ${seconds}d';
    }

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hoursStr:$minutesStr:$secondsStr';
    }
    return '$minutesStr:$secondsStr';
  }

  static String truncateText(
    String? text,
    int maxLength, {
    String suffix = '...',
  }) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$suffix';
  }

  static String capitalize(String? text) {
    if (text == null || text.trim().isEmpty) return '';
    final trimmed = text.trim();
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }
}
