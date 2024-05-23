// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  /// Formats the date to a readable string.
  /// e.g., Wednesday 12 May
  String formatToWeekdayDayMonth() {
    final weekday = DateFormat('EEEE').format(this); // e.g., Wednesday
    final day = this.day; // Day of the month (1-31)
    final month = DateFormat('MMMM').format(this); // e.g., May

    return '$weekday $day $month';
  }

  /// Formats the date to a readable string.
  /// e.g., Monday - 12 May 2021 - 10:00 AM
  String formatToWeekdayDayMonthYearTime() {
    final weekday = DateFormat('EEEE').format(this); // e.g., Wednesday
    final day = this.day; // Day of the month (1-31)
    final month = DateFormat('MMMM').format(this); // e.g., May
    final year = this.year; // e.g., 2021
    final time = DateFormat.jm().format(this); // e.g., 10:00 AM

    return '$weekday - $day $month $year - $time';
  }

  /// Formats the date to a readable string.
  /// e.g., 2024-05-12
  String formatToYearMonthDay() {
    return '$year-$month-$day';
  }

  /// Formats the date to a readable string.
  /// e.g., 7:00 AM 23-7-2023
  String formatToTimeDayMonthYear() {
    final time = DateFormat.jm().format(this); // e.g., 10:00 AM
    return '$time $day-$month-$year';
  }

  /// Formats the date to a readable string.
  /// e.g., 10 years, 7 months
  String formatToYearsMonths() {
    final years = year;
    final months = month;
    return '$years years, $months months';
  }
}
