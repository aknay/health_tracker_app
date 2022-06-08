import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/models/blood_pressure_reading.dart';
import 'package:intl/intl.dart';

class BloodPressureDayAverage {
  final int index;
  final List<BloodPressureReading> reading;
  final DateTime dateTime;
  final bool useSystolic;

  BloodPressureDayAverage(this.index, this.dateTime, this.reading, this.useSystolic);

  double get average {
    return reading.isEmpty ? 0 : reading.map((e) => useSystolic ? e.systolic : e.diastolic).average;
  }

  bool get isEmptyReadings => reading.isEmpty;

  int get weekday => dateTime.weekday;

  String get stringDate {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(dateTime);
  }
}

class BloodPressureReadingStatistic {
  final List<BloodPressureReading> reading;
  final int dayCount;

  BloodPressureReadingStatistic(this.reading, this.dayCount);

  double get systolicAverage => reading.isEmpty ? 0 : reading.map((e) => e.systolic).average;

  double get diastolicAverage => reading.isEmpty ? 0 : reading.map((e) => e.diastolic).average;

  num get minValue => reading.isEmpty ? 0 : reading.map((e) => e.diastolic).reduce(min);

  num get maxValue => reading.isEmpty ? 0 : reading.map((e) => e.systolic).reduce(max);

  double get averageSystolicAsFixedPrecision {
    return systolicAverage.toInt().toDouble();
    // return optionOf(double.tryParse(g)).fold(() => 0, (a) => a);
  }

  double get averageDiastolicAsFixedPrecision {
    final g = diastolicAverage.toStringAsFixed(1);
    return optionOf(double.tryParse(g)).fold(() => 0, (a) => a);
  }

  List<BloodPressureDayAverage> getBloodGlucoseDayAverage(bool useSystolic) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    final lastDays = List<int>.generate(dayCount - 1, (i) => i + 1)
        .map((e) => now.subtract(Duration(days: e)))
        .map((e) => DateTime(e.year, e.month, e.day))
        .toList();

    final lastDaysWithToday = lastDays + [today];

    lastDaysWithToday.sort((a, b) => a.compareTo(b));

    final bloodGlucoseDayAverageList = lastDaysWithToday
        .mapIndexed((index, date) => BloodPressureDayAverage(
            index, date, reading.where((e) => e.dateTimeWithoutTime.compareTo(date) == 0).toList(), useSystolic))
        .toList();

    bloodGlucoseDayAverageList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return bloodGlucoseDayAverageList;
  }

  int get maxIndex => getBloodGlucoseDayAverage(false).map((e) => e.index).reduce(max);

  String getBottomLabel(int index) {
    if (dayCount == 7) {
      final text = getBloodGlucoseDayAverage(false).where((element) => element.index == index);

      if (text.isNotEmpty) {
        return text.first.stringDate;
      }
    } else if (dayCount == 30) {
      if (index % 6 == 0) {
        final text = getBloodGlucoseDayAverage(false).where((element) => element.index == index);

        if (text.isNotEmpty) {
          return text.first.stringDate;
        }
      }
    } else if (dayCount == 90) {
      if (index % 18 == 0) {
        final text = getBloodGlucoseDayAverage(false).where((element) => element.index == index);

        if (text.isNotEmpty) {
          return text.first.stringDate;
        }
      }
    }

    return "";
  }
}
