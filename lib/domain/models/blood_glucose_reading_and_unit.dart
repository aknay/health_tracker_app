// import 'package:dartz/dartz.dart';
// import 'package:intl/intl.dart';
//
// import 'blood_glucose_reading.dart';
// import 'enums.dart';
//
// class BloodGlucoseReadingAndUnit {
//   final String reading;
//   final String unit;
//   final DateTime dateTime;
//   final Option<Routine> routine;
//
//   BloodGlucoseReadingAndUnit(this.reading, this.unit, this.dateTime, this.routine);
//
//   factory BloodGlucoseReadingAndUnit.fromBloodGlucoseReading(
//       BloodGlucoseReading v, BloodGlucoseUnit systemBloodGlucoseUnit) {
//     final savedUnit = BloodGlucoseUnit.values.where((element) => element.toString() == v.unitType).toList().first;
//     late String value;
//     if (savedUnit == systemBloodGlucoseUnit) {
//       value = v.value.toString();
//     } else {
//       switch (savedUnit) {
//         case BloodGlucoseUnit.MMOL_DIVIDED_BY_L:
//           value = (v.value * 18).toInt().toString();
//           break;
//
//         case BloodGlucoseUnit.MG_DIVIDED_BY_DL:
//           value = (v.value / 18).toString();
//           break;
//       }
//     }
//
//     // final dateTimeWithoutTime =  DateTime(v.dateTime.year, v.dateTime.month, v.dateTime.day, 0, 0, 0);
//
//     return BloodGlucoseReadingAndUnit(
//         value, systemBloodGlucoseUnit.toHumanReadable, v.dateTime, fromRoutineStringToEnum(v.routine));
//   }
//
//   String get timeOfDay => _toFormattedTime(dateTime);
//
//   int get timestamp => dateTime.millisecondsSinceEpoch;
//
//   // String get amount {
//   //   final savedUnit = BloodGlucoseUnit.values.where((element) => element.toString() == reading.unitType).toList().first;
//   //
//   //   if (savedUnit == systemBloodGlucoseUnit) {
//   //     return reading.value.toString();
//   //   }
//   //
//   //   switch (savedUnit) {
//   //     case BloodGlucoseUnit.MMOL_DIVIDED_BY_L:
//   //       return (reading.value * 18).toInt().toString();
//   //
//   //     case BloodGlucoseUnit.MG_DIVIDED_BY_DL:
//   //       return (reading.value / 18).toString();
//   //   }
//   // }
//
//   // BloodGlucoseReadingAndUnit get readingAndUnit => BloodGlucoseReadingAndUnit.fromBloodGlucoseReading(reading, systemBloodGlucoseUnit);
//
//   // Option<Routine> get period => fromRoutineStringToEnum(reading.routine);
//
//   // String get unit => systemBloodGlucoseUnit.toHumanReadable;
//
//   DateTime get dateTimeWithoutTime {
//     // this is for grouping by date without time
//     return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
//   }
//
//   // int get timestamp => reading.dateTime.millisecondsSinceEpoch; // this is for sorting with timestamp
//
//   String _toFormattedTime(DateTime dateTime) {
//     final format = DateFormat.jm(); //"6:00 AM"
//     return format.format(dateTime);
//   }
// }
