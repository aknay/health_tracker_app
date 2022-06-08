import 'package:dartz/dartz.dart';

enum BloodPressureRating {
  LOW_BLOOD_PRESSURE,
  NORMAL,
  ELEVATED,
  HIGH_BLOOD_PRESSURE_STATE_1,
  HIGH_BLOOD_PRESSURE_STATE_2,
  HYPERTENSIVE_CRISIS
}

enum BloodPressureRatingError {
  NOT_VALID, //
  SYSTOLIC_READING_SHOULD_BE_HIGHER_THAN_DIASTOLIC,
  READING_TOO_LOW
}

Either<BloodPressureRatingError, Option<BloodPressureRating>> getBloodPressureRating(
    {required int systolicReading, required int diastolicReading}) {
  if (systolicReading < diastolicReading) {
    return const Left(BloodPressureRatingError.SYSTOLIC_READING_SHOULD_BE_HIGHER_THAN_DIASTOLIC);
  }

  if (systolicReading < 70 || diastolicReading < 40) {
    return const Left(BloodPressureRatingError.READING_TOO_LOW);
  }

  if ((systolicReading - diastolicReading) < 9) {
    return const Left(BloodPressureRatingError.NOT_VALID);
  }

  if (systolicReading <= 89 && diastolicReading <= 59) {
    return const Right(Some(BloodPressureRating.LOW_BLOOD_PRESSURE));
  }

  if (systolicReading < 120 && diastolicReading < 80) {
    return const Right(Some(BloodPressureRating.NORMAL));
  }
  if (systolicReading < 140 && diastolicReading < 90) {
    return const Right(Some(BloodPressureRating.ELEVATED));
  }

  if (systolicReading < 180 && diastolicReading < 100) {
    return const Right(Some(BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_1));
  }

  if (systolicReading > 190 || diastolicReading > 100) {
    return const Right(Some(BloodPressureRating.HYPERTENSIVE_CRISIS));
  }

  if (systolicReading >= 180 || diastolicReading >= 100) {
    return const Right(Some(BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_2));
  }

  return const Right(None());
}
