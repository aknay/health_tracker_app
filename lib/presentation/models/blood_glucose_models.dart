import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/models/blood_glucose_reading.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:intl/intl.dart';

class BloodGlucoseDayAverage {
  final int index;
  final List<BloodGlucoseReading> reading;
  final DateTime dateTime;
  final BloodGlucoseUnit systemBloodGlucoseUnit;

  BloodGlucoseDayAverage(this.index, this.dateTime, this.reading, this.systemBloodGlucoseUnit);

  double get average {
    return reading.isEmpty ? 0 : reading.map((e) => e.getValueBySystemBloodGlucoseUnit(systemBloodGlucoseUnit)).average;
  }

  bool get isEmptyReadings => reading.isEmpty;

  int get weekday => dateTime.weekday;

  String get stringDate {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(dateTime);
  }
}

class BloodGlucoseStatistic {
  final List<BloodGlucoseReading> reading;
  final BloodGlucoseUnit systemBloodGlucoseUnit;
  final int dayCount;

  BloodGlucoseStatistic(this.reading, this.systemBloodGlucoseUnit, this.dayCount);

  double get average {
    return reading.isEmpty ? 0 : reading.map((e) => e.getValueBySystemBloodGlucoseUnit(systemBloodGlucoseUnit)).average;
  }

  double get minValue {
    return reading.isEmpty
        ? 0
        : reading.map((e) => e.getValueBySystemBloodGlucoseUnit(systemBloodGlucoseUnit)).reduce(min);
  }

  double get maxValue {
    return reading.isEmpty
        ? 0
        : reading.map((e) => e.getValueBySystemBloodGlucoseUnit(systemBloodGlucoseUnit)).reduce(max);
  }

  double get averageAsFixedPrecision {
    final g = average.toStringAsFixed(1);
    return optionOf(double.tryParse(g)).fold(() => 0, (a) => a);
  }

  List<BloodGlucoseDayAverage> getBloodGlucoseDayAverage() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    final lastSixDays = List<int>.generate(dayCount - 1, (i) => i + 1)
        .map((e) => now.subtract(Duration(days: e)))
        .map((e) => DateTime(e.year, e.month, e.day))
        .toList();

    final lastSixDaysWithToday = lastSixDays + [today];

    lastSixDaysWithToday.sort((a, b) => a.compareTo(b));

    final bloodGlucoseDayAverageList = lastSixDaysWithToday
        .mapIndexed((index, date) => BloodGlucoseDayAverage(index, date,
            reading.where((e) => e.dateTimeWithoutTime.compareTo(date) == 0).toList(), systemBloodGlucoseUnit))
        .toList();

    bloodGlucoseDayAverageList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return bloodGlucoseDayAverageList;
  }

  int get maxIndex => getBloodGlucoseDayAverage().map((e) => e.index).reduce(max);

  String getBottomLabel(int index) {
    if (dayCount == 7) {
      final text = getBloodGlucoseDayAverage().where((element) => element.index == index);

      if (text.isNotEmpty) {
        return text.first.stringDate;
      }
    } else if (dayCount == 30) {
      if (index % 6 == 0) {
        final text = getBloodGlucoseDayAverage().where((element) => element.index == index);

        if (text.isNotEmpty) {
          return text.first.stringDate;
        }
      }
    } else if (dayCount == 90) {
      if (index % 18 == 0) {
        final text = getBloodGlucoseDayAverage().where((element) => element.index == index);

        if (text.isNotEmpty) {
          return text.first.stringDate;
        }
      }
    }

    return "";
  }
}
