import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

part 'blood_pressure_reading.g.dart';

@HiveType(typeId: 0)
class BloodPressureReading extends HiveObject {
  static const String tableName = 'blood_pressure_readings';
  @HiveField(0)
  String id;
  @HiveField(1)
  int systolic;
  @HiveField(2)
  int diastolic;
  @HiveField(3)
  DateTime dateTime;
  @HiveField(4)
  String? bodyPosition;
  @HiveField(5)
  String? armLocation;
  @HiveField(6)
  String? note;

  BloodPressureReading(
      {required this.id,
      required this.systolic,
      required this.diastolic,
      required this.dateTime,
      required this.bodyPosition,
      required this.armLocation,
      required this.note});

  factory BloodPressureReading.withNew(DateTime dateTime,
      {required int systolic,
      required int diastolic,
      required Option<String> note,
      required Option<String> bodyPosition,
      required Option<String> armLocation}) {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    return BloodPressureReading(
        id: timestamp.toString(),
        systolic: systolic,
        diastolic: diastolic,
        dateTime: dateTime,
        bodyPosition: bodyPosition.fold(() => null, (a) => a),
        armLocation: armLocation.fold(() => null, (a) => a),
        note: note.fold(() => null, (a) => a));
  }

  factory BloodPressureReading.fromIdUpdate(String id, BloodPressureReading r) {
    return BloodPressureReading(
        id: id,
        systolic: r.systolic,
        diastolic: r.diastolic,
        armLocation: r.armLocation,
        bodyPosition: r.bodyPosition,
        dateTime: r.dateTime,
        note: r.note);
  }

  DateTime get dateTimeWithoutTime {
    // this is for grouping by date without time
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
  }
}
