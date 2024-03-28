import 'package:dartz/dartz.dart';

enum BloodPressureRating {
  kLowBloodPressure,
  kNormal,
  kElevated,
  kHighBloodPressureState1,
  kHighBloodPressureState2,
  kHypertensiveCrisis
}

enum BloodPressureRatingError {
  kNotValid, //
  kSystolicReadingShouldBeHigherThanDiastolic,
  kReadingTooLow
}

Either<BloodPressureRatingError, Option<BloodPressureRating>> getBloodPressureRating(
    {required int systolicReading, required int diastolicReading}) {
  if (systolicReading < diastolicReading) {
    return const Left(BloodPressureRatingError.kSystolicReadingShouldBeHigherThanDiastolic);
  }

  if (systolicReading < 70 || diastolicReading < 40) {
    return const Left(BloodPressureRatingError.kReadingTooLow);
  }

  if ((systolicReading - diastolicReading) < 9) {
    return const Left(BloodPressureRatingError.kNotValid);
  }

  if (systolicReading <= 89 && diastolicReading <= 59) {
    return const Right(Some(BloodPressureRating.kLowBloodPressure));
  }

  if (systolicReading < 120 && diastolicReading < 80) {
    return const Right(Some(BloodPressureRating.kNormal));
  }
  if (systolicReading < 140 && diastolicReading < 90) {
    return const Right(Some(BloodPressureRating.kElevated));
  }

  if (systolicReading < 180 && diastolicReading < 100) {
    return const Right(Some(BloodPressureRating.kHighBloodPressureState1));
  }

  if (systolicReading > 190 || diastolicReading > 100) {
    return const Right(Some(BloodPressureRating.kHypertensiveCrisis));
  }

  if (systolicReading >= 180 || diastolicReading >= 100) {
    return const Right(Some(BloodPressureRating.kHighBloodPressureState2));
  }

  return const Right(None());
}
