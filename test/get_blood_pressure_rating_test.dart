import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/blood_pressure_calculator.dart';
import 'package:test/test.dart';

void main() {
  test('Getting blood pressure should be correct', () {
    ///invalid blood pressure
    final reading1 = getBloodPressureRating(systolicReading: 69, diastolicReading: 40);
    expect(reading1.isLeft(), true);
    final reading2 = getBloodPressureRating(systolicReading: 70, diastolicReading: 39);
    expect(reading2.isLeft(), true);
    final reading3 = getBloodPressureRating(systolicReading: 80, diastolicReading: 90);
    expect(reading3.isLeft(), true);

    ///low blood pressure
    final lbp1 = getBloodPressureRating(systolicReading: 89, diastolicReading: 59);
    expect(lbp1, const Right(Some(BloodPressureRating.LOW_BLOOD_PRESSURE)));
    final lbp2 = getBloodPressureRating(systolicReading: 70, diastolicReading: 40);
    expect(lbp2, const Right(Some(BloodPressureRating.LOW_BLOOD_PRESSURE)));

    ///normal blood pressure
    final nbp1 = getBloodPressureRating(systolicReading: 119, diastolicReading: 79);
    expect(nbp1, const Right(Some(BloodPressureRating.NORMAL)));
    final nbp2 = getBloodPressureRating(systolicReading: 90, diastolicReading: 60);
    expect(nbp2, const Right(Some(BloodPressureRating.NORMAL)));
    final nbp3 = getBloodPressureRating(systolicReading: 89, diastolicReading: 61);
    expect(nbp3, const Right(Some(BloodPressureRating.NORMAL)));
    final nbp4 = getBloodPressureRating(systolicReading: 70, diastolicReading: 61);
    expect(nbp4, const Right(Some(BloodPressureRating.NORMAL)));
    final nbp5 = getBloodPressureRating(systolicReading: 89, diastolicReading: 79);
    expect(nbp5, const Right(Some(BloodPressureRating.NORMAL)));
    final nbp6 = getBloodPressureRating(systolicReading: 91, diastolicReading: 40);
    expect(nbp6, const Right(Some(BloodPressureRating.NORMAL)));
    final nbp7 = getBloodPressureRating(systolicReading: 119, diastolicReading: 40);
    expect(nbp7, const Right(Some(BloodPressureRating.NORMAL)));

    ///elevated blood pressure
    final ebp1 = getBloodPressureRating(systolicReading: 139, diastolicReading: 89);
    expect(ebp1, const Right(Some(BloodPressureRating.ELEVATED)));
    final ebp2 = getBloodPressureRating(systolicReading: 120, diastolicReading: 80);
    expect(ebp2, const Right(Some(BloodPressureRating.ELEVATED)));
    final ebp3 = getBloodPressureRating(systolicReading: 139, diastolicReading: 40);
    expect(ebp3, const Right(Some(BloodPressureRating.ELEVATED)));
    final ebp4 = getBloodPressureRating(systolicReading: 120, diastolicReading: 40);
    expect(ebp4, const Right(Some(BloodPressureRating.ELEVATED)));

    ///high blood pressure
    final hbp1 = getBloodPressureRating(systolicReading: 179, diastolicReading: 99);
    expect(hbp1, const Right(Some(BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_1)));
    final hbp2 = getBloodPressureRating(systolicReading: 140, diastolicReading: 90);
    expect(hbp2, const Right(Some(BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_1)));
    final hbp3 = getBloodPressureRating(systolicReading: 179, diastolicReading: 40);
    expect(hbp3, const Right(Some(BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_1)));

    ///very high blood pressure
    final vhbp1 = getBloodPressureRating(systolicReading: 140, diastolicReading: 100);
    expect(vhbp1, const Right(Some(BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_2)));
    final vhbp2 = getBloodPressureRating(systolicReading: 190, diastolicReading: 100);
    expect(vhbp2, const Right(Some(BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_2)));

    ///very very high blood pressure
    final vvhbp1 = getBloodPressureRating(systolicReading: 190, diastolicReading: 101);
    expect(vvhbp1, const Right(Some(BloodPressureRating.HYPERTENSIVE_CRISIS)));
    final vvhbp2 = getBloodPressureRating(systolicReading: 191, diastolicReading: 100);
    expect(vvhbp2, const Right(Some(BloodPressureRating.HYPERTENSIVE_CRISIS)));
  });
}
