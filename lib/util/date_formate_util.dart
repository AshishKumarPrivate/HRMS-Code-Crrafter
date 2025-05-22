import 'package:intl/intl.dart';

class DateFormatter {

  /// Input: ISO format (yyyy-MM-dd or full ISO datetime)
  /// Output: dd-MM-yyyy
  static String formatToDdMmYyyy(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  /// Input: ISO format (yyyy-MM-dd or full ISO datetime)
  /// Output: MM/dd/yyyy
  static String formatToMmDdYyyy(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MM/dd/yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }
  /// Format: 16 May 2025, 12:24 PM (in UTC)
  ///   /// Input: ISO format datetime string (yyyy-MM-ddTHH:mm:ssZ)
  //   /// Output: Time part from "dd MMM yyyy, hh:mm a", e.g., "12:24 PM"
  static String formatUtcToReadable(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr).toUtc(); // Ensure it's in UTC
      return extractTimeFromReadable(DateFormat('dd MMM yyyy, hh:mm a').format(date));
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }
  /// Extracts only the time from a readable datetime string like:
  /// "Login Time: 16 May 2025, 12:24 PM" → returns "12:24 PM"
  static String extractTimeFromReadable(String? readableDateTime) {
    if (readableDateTime == null || readableDateTime.isEmpty) return 'N/A';
    try {
      // Find last comma and return substring after it
      final parts = readableDateTime.split(',');
      if (parts.length >= 2) {
        return parts.last.trim(); // returns "12:24 PM"
      }
      return 'Invalid Format';
    } catch (e) {
      return 'Invalid Format';
    }
  }





  /// Format: 2025-04-17 (ISO Standard)
  ///   /// Input: ISO format (yyyy-MM-dd or full ISO datetime)
  //   /// Output: yyyy-MM-dd
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
  ///   /// Input: ISO format (yyyy-MM-dd or full ISO datetime)
  //   /// Output: Full month name, e.g., April 17, 2025
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
  /// Input: ISO format (yyyy-MM-dd or full ISO datetime)
  //   /// Output: Short month format, e.g., 17 Apr 2025
  static String formatToShortMonth(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }
  /// Input: ISO format (yyyy-MM-dd or full ISO datetime)
  /// Output: dd MMM yyyy in local time zone
  static String formatToyyyyddMM(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }
  /// Input format: dd/MM/yyyy
  /// Output: dd, MM, yyyy (separately returned or formatted string)
  static String formatCustomDdMmYyyy(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateFormat('yyyy-MM-dd').parseStrict(dateStr);
      return DateFormat('dd MMM yyyy').format(date); // Custom output
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
