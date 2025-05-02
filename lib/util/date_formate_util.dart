import 'package:intl/intl.dart';

class DateFormatter {
  /// Format: 17-04-2025
  static String formatToDdMmYyyy(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  /// Format: 04/17/2025
  static String formatToMmDdYyyy(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MM/dd/yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  /// Format: 2025-04-17 (ISO Standard)
  static String formatToIso(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  /// Format: April 17, 2025
  static String formatToLongDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  /// Format: 17 Apr 2025
  static String formatToShortMonth(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
