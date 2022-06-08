import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/blood_pressure_calculator.dart';
import 'package:healthtracker/domain/models/blood_pressure_reading.dart';
import 'package:healthtracker/domain/models/error.dart';
import 'package:healthtracker/domain/repository/blood_pressure_reading_repository.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:rxdart/rxdart.dart';

class BloodPressureAddingViewModel extends ViewModel {
  final Option<BloodPressureReading> readingOrNone;

  //repository
  final _repo = GetIt.instance<BloodPressureReadingRepository>();

  // behavior subject
  final _timeOfDayBehaviorSubject = BehaviorSubject<TimeOfDay>.seeded(TimeOfDay.now());
  final _dateWithoutTimeBehaviorSubject = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _systolicReadingBehaviorSubject = BehaviorSubject<int>();
  final _diastolicReadingBehaviorSubject = BehaviorSubject<int>();

  //stream
  Stream<TimeOfDay> get timeOfDayStream => _timeOfDayBehaviorSubject.asBroadcastStream();

  Stream<DateTime> get dateWithoutTimeStream => _dateWithoutTimeBehaviorSubject.asBroadcastStream();

  Stream<Either<BloodPressureRatingError, Option<BloodPressureRating>>> get bloodGlucoseRatingStream =>
      CombineLatestStream.combine2(
          _systolicReadingBehaviorSubject,
          _diastolicReadingBehaviorSubject,
          (int systolicReading, int diastolicReading) =>
              getBloodPressureRating(systolicReading: systolicReading, diastolicReading: diastolicReading));

  BloodPressureAddingViewModel(this.readingOrNone) {
    readingOrNone.fold(() {
      _systolicReadingBehaviorSubject.add(110);
      _diastolicReadingBehaviorSubject.add(70);
    }, (a) {
      _systolicReadingBehaviorSubject.add(a.systolic);
      _diastolicReadingBehaviorSubject.add(a.diastolic);
      final date = a.dateTime;
      _timeOfDayBehaviorSubject.add(TimeOfDay(hour: date.hour, minute: date.minute));
      _dateWithoutTimeBehaviorSubject.add(date);
    });
  }

  void setSystolicBloodPressure(int v) {
    _systolicReadingBehaviorSubject.add(v);
  }

  void setDiastolicBloodPressure(int v) {
    _diastolicReadingBehaviorSubject.add(v);
  }

  bool isEditing() {
    return readingOrNone.isSome();
  }

  void setTimeOfDay(TimeOfDay v) {
    _timeOfDayBehaviorSubject.add(v);
  }

  void setDateWithoutTime(DateTime v) {
    _dateWithoutTimeBehaviorSubject.add(v);
  }

  Either<BloodPressureRatingError, Unit> isFormValid() {
    final ratingOrError = getBloodPressureRating(
        systolicReading: _systolicReadingBehaviorSubject.value,
        diastolicReading: _diastolicReadingBehaviorSubject.value);

    return ratingOrError.fold((l) => Left(l), (r) => const Right(unit));
  }

  addValue() async {
    final dateWithoutTime = _dateWithoutTimeBehaviorSubject.value;
    final timeOfDay = _timeOfDayBehaviorSubject.value;

    final date =
        DateTime(dateWithoutTime.year, dateWithoutTime.month, dateWithoutTime.day, timeOfDay.hour, timeOfDay.minute);

    final reading = BloodPressureReading.withNew(date,
        systolic: _systolicReadingBehaviorSubject.value,
        diastolic: _diastolicReadingBehaviorSubject.value,
        note: const None(),
        bodyPosition: const None(),
        armLocation: const None());

    _repo.insert(reading);
  }

  updateValue() async {
    readingOrNone.fold(() => null, (a) {
      final dateWithoutTime = _dateWithoutTimeBehaviorSubject.value;
      final timeOfDay = _timeOfDayBehaviorSubject.value;

      final date = DateTime(
          dateWithoutTime.year, //
          dateWithoutTime.month,
          dateWithoutTime.day,
          timeOfDay.hour,
          timeOfDay.minute);

      final newReading = BloodPressureReading.withNew(date, //
          systolic: _systolicReadingBehaviorSubject.value,
          diastolic: _diastolicReadingBehaviorSubject.value,
          note: const None(),
          bodyPosition: const None(),
          armLocation: const None());

      _repo.updateById(a.id, newReading);
    });
  }

  Future<Either<RetrievedError, Unit>> deleteEntry() async {
    return readingOrNone.fold(() => Left(RetrievedError("reading is none")), (a) async {
      final result = await _repo.deleteById(a.id);
      return result;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
