import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import 'enums.dart';

part 'blood_glucose_reading.g.dart';

@HiveType(typeId: 1)
class BloodGlucoseReading extends HiveObject {
  static const String tableName = 'blood_glucose_readings';

  @HiveField(0)
  String id;
  @HiveField(1)
  double value;
  @HiveField(2)
  String unitType;
  @HiveField(3)
  String routine;
  @HiveField(4)
  DateTime dateTime;
  @HiveField(5)
  String? note;

  BloodGlucoseReading(
      {required this.id, //
      required this.value,
      required this.unitType,
      required this.routine,
      required this.dateTime,
      required this.note});

  factory BloodGlucoseReading.fromIdUpdate(String id, BloodGlucoseReading r) {
    return BloodGlucoseReading(
        id: id,
        //
        value: r.value,
        unitType: r.unitType,
        routine: r.routine,
        dateTime: r.dateTime,
        note: r.note);
  }

  factory BloodGlucoseReading.withNew(
      double bloodGlucose, //
      BloodGlucoseUnit unit,
      Routine routine,
      DateTime dateTime,
      Option<String> note) {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    return BloodGlucoseReading(
        id: timestamp.toString(),
        //
        value: bloodGlucose,
        unitType: unit.toString(),
        routine: routine.toString(),
        dateTime: dateTime,
        note: note.fold(() => null, (a) => a));
  }

  double getValueBySystemBloodGlucoseUnit(BloodGlucoseUnit systemBloodGlucoseUnit) {
    final savedUnit = BloodGlucoseUnit.values.where((element) => element.toString() == unitType).toList().first;
    if (savedUnit == systemBloodGlucoseUnit) {
      return value;
    } else {
      switch (savedUnit) {
        case BloodGlucoseUnit.kMmolDividedByL:
          return value * 18;

        case BloodGlucoseUnit.kMgDividedByDl:
          return value / 18;
      }
    }
  }

  DateTime get dateTimeWithoutTime {
    // this is for grouping by date without time
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
  }
}
