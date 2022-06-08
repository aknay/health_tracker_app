import 'package:healthtracker/domain/models/enums.dart';

String getReadingByBloodGlucoseUnit(double value, BloodGlucoseUnit unit) {
  switch (unit) {
    case BloodGlucoseUnit.MMOL_DIVIDED_BY_L:
      return value.toStringAsFixed(1);

    case BloodGlucoseUnit.MG_DIVIDED_BY_DL:
      return value.toInt().toString();
  }
}
