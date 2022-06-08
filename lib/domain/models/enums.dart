import 'package:dartz/dartz.dart';

enum BodyPosition { STANDING, SITTING, LYING_DOWN, RECLINING }

extension BodyPositionExtension on BodyPosition {
  String get name {
    switch (this) {
      case BodyPosition.STANDING:
        return 'STANDING';
      case BodyPosition.SITTING:
        return 'SITTING';
      case BodyPosition.LYING_DOWN:
        return 'LYING_DOWN';
      case BodyPosition.RECLINING:
        return 'RECLINING';
    }
  }
}

enum ArmLocation { LEFT_WRIST, RIGHT_WRIST, LEFT_UPPER_ARM, RIGHT_UPPER_ARM }

extension ArmLocationExtension on ArmLocation {
  String get name {
    switch (this) {
      case ArmLocation.LEFT_WRIST:
        return 'LEFT_WRIST';
      case ArmLocation.RIGHT_WRIST:
        return 'RIGHT_WRIST';
      case ArmLocation.LEFT_UPPER_ARM:
        return 'LEFT_UPPER_ARM';
      case ArmLocation.RIGHT_UPPER_ARM:
        return 'RIGHT_UPPER_ARM';
    }
  }
}

enum Routine {
  JUST_AFTER_WAKE_UP,
  BEFORE_BREAKFAST,
  AFTER_BREAKFAST,
  BEFORE_LUNCH,
  AFTER_LUNCH,
  BEFORE_DINNER,
  AFTER_DINNER,
  JUST_BEFORE_BED_TIME,
  OTHER,
}

Option<Routine> fromRoutineStringToEnum(String v) {
  final r = Routine.values.where((element) => element.toString() == v).toList();
  return r.isEmpty ? const None() : Some(r.first);
}

enum BloodGlucoseUnit {
  MMOL_DIVIDED_BY_L,
  MG_DIVIDED_BY_DL,
}

extension BloodGlucoseUnitExtension on BloodGlucoseUnit {
  String get toHumanReadable {
    switch (this) {
      case BloodGlucoseUnit.MMOL_DIVIDED_BY_L:
        return "mmol/L";
      case BloodGlucoseUnit.MG_DIVIDED_BY_DL:
        return "mg/dL";
    }
  }
}
