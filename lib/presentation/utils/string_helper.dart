import 'package:healthtracker/domain/models/enums.dart';

String getReadingByBloodGlucoseUnit(double value, BloodGlucoseUnit unit) {
  switch (unit) {
    case BloodGlucoseUnit.kMmolDividedByL:
      return value.toStringAsFixed(1);

    case BloodGlucoseUnit.kMgDividedByDl:
      return value.toInt().toString();
  }
}
