import 'package:dartz/dartz.dart';

enum BodyPosition { kStanding, kSitting, kLyingDown, kReclinging }

extension BodyPositionExtension on BodyPosition {
  String get name {
    switch (this) {
      case BodyPosition.kStanding:
        return 'STANDING';
      case BodyPosition.kSitting:
        return 'SITTING';
      case BodyPosition.kLyingDown:
        return 'LYING_DOWN';
      case BodyPosition.kReclinging:
        return 'RECLINING';
    }
  }
}

enum ArmLocation { kLeftWrist, kRightWrist, kLeftUpperArm, kRightUpperArm }

extension ArmLocationExtension on ArmLocation {
  String get name {
    switch (this) {
      case ArmLocation.kLeftWrist:
        return 'LEFT_WRIST';
      case ArmLocation.kRightWrist:
        return 'RIGHT_WRIST';
      case ArmLocation.kLeftUpperArm:
        return 'LEFT_UPPER_ARM';
      case ArmLocation.kRightUpperArm:
        return 'RIGHT_UPPER_ARM';
    }
  }
}

enum Routine {
  kJustAfterWakeUp,
  kBeforeBreakfast,
  kAfterBreakfast,
  kBeforeLunch,
  kAfterLunch,
  kBeforeDinner,
  kAfterDinner,
  kJustBeforeBedTime,
  kOther,
}

Option<Routine> fromRoutineStringToEnum(String v) {
  final r = Routine.values.where((element) => element.toString() == v).toList();
  return r.isEmpty ? const None() : Some(r.first);
}

enum BloodGlucoseUnit {
  kMmolDividedByL,
  kMgDividedByDl,
}

extension BloodGlucoseUnitExtension on BloodGlucoseUnit {
  String get toHumanReadable {
    switch (this) {
      case BloodGlucoseUnit.kMmolDividedByL:
        return "mmol/L";
      case BloodGlucoseUnit.kMgDividedByDl:
        return "mg/dL";
    }
  }
}
