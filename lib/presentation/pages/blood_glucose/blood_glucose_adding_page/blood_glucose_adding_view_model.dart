import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/models/blood_glucose_reading.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/domain/models/error.dart';
import 'package:healthtracker/domain/repository/blood_glucose_reading_repository.dart';
import 'package:healthtracker/domain/services/units_service.dart';
import 'package:healthtracker/presentation/utils/string_helper.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:rxdart/rxdart.dart';

enum ErrorType { kEmptyRoutine, kEmptyBloodGlucose }

enum BloodGlucoseRating { kExcellent, kGood, kAcceptable, kPoor }

class ReadingAndUnit {
  final Option<double> reading;
  final BloodGlucoseUnit unit;

  ReadingAndUnit(this.reading, this.unit);

  String get unitAsText => unit.toHumanReadable;

  String get readingAsText => reading.fold(() => "", (a) => getReadingByBloodGlucoseUnit(a, unit));

  Option<BloodGlucoseRating> getRatingOrNone(Routine routine) {
    switch (routine) {
      case Routine.kJustAfterWakeUp:
        return _getRatingForBeforeFood();
      case Routine.kBeforeBreakfast:
        return _getRatingForBeforeFood();
      case Routine.kAfterBreakfast:
        return _getRatingForAfterFood();
      case Routine.kBeforeLunch:
        return _getRatingForBeforeFood();
      case Routine.kAfterLunch:
        return _getRatingForAfterFood();
      case Routine.kBeforeDinner:
        return _getRatingForBeforeFood();
      case Routine.kAfterDinner:
        return _getRatingForAfterFood();
      case Routine.kJustBeforeBedTime:
        return _getRatingForAfterFood();
      case Routine.kOther:
        return const None();
    }
  }

  Option<BloodGlucoseRating> _getRatingForBeforeFood() {
    return reading.fold(() => const None(), (value) {
      switch (unit) {
        case BloodGlucoseUnit.kMmolDividedByL:
          if (value >= 4.0 && value <= 6.0) {
            return const Some(BloodGlucoseRating.kExcellent);
          } else if (value > 6.0 && value <= 8.0) {
            return const Some(BloodGlucoseRating.kGood);
          } else if (value > 8.0 && value <= 10.0) {
            return const Some(BloodGlucoseRating.kAcceptable);
          } else if (value > 10.0) {
            return const Some(BloodGlucoseRating.kPoor);
          }

          return const None();

        case BloodGlucoseUnit.kMgDividedByDl:
          if (value >= 72 && value <= 109) {
            return const Some(BloodGlucoseRating.kExcellent);
          } else if (value > 109 && value <= 144) {
            return const Some(BloodGlucoseRating.kGood);
          } else if (value > 144 && value <= 180) {
            return const Some(BloodGlucoseRating.kAcceptable);
          } else if (value > 180) {
            return const Some(BloodGlucoseRating.kPoor);
          }

          return const None();
      }
    });
  }

  Option<BloodGlucoseRating> _getRatingForAfterFood() {
    return reading.fold(() => const None(), (value) {
      switch (unit) {
        case BloodGlucoseUnit.kMmolDividedByL:
          if (value >= 5.0 && value <= 7.0) {
            return const Some(BloodGlucoseRating.kExcellent);
          } else if (value > 7.0 && value <= 10.0) {
            return const Some(BloodGlucoseRating.kGood);
          } else if (value > 10.0 && value <= 13.0) {
            return const Some(BloodGlucoseRating.kAcceptable);
          } else if (value > 13.0) {
            return const Some(BloodGlucoseRating.kPoor);
          }

          return const None();

        case BloodGlucoseUnit.kMgDividedByDl:
          if (value >= 90 && value <= 126) {
            return const Some(BloodGlucoseRating.kExcellent);
          } else if (value > 126 && value <= 180) {
            return const Some(BloodGlucoseRating.kGood);
          } else if (value > 180 && value <= 234) {
            return const Some(BloodGlucoseRating.kAcceptable);
          } else if (value > 234) {
            return const Some(BloodGlucoseRating.kPoor);
          }

          return const None();
      }
    });
  }

  factory ReadingAndUnit.asDefault() {
    return ReadingAndUnit(const None(), BloodGlucoseUnit.kMmolDividedByL);
  }
}

class BloodGlucoseAddingViewModel extends ViewModel {
  final Option<BloodGlucoseReading> readingOrNone;

  // behavior subject
  final _bloodGlucoseReading = BehaviorSubject<ReadingAndUnit>();
  final _routineBehaviorSubject = BehaviorSubject<Option<Routine>>.seeded(const None());
  final _timeOfDayBehaviorSubject = BehaviorSubject<TimeOfDay>.seeded(TimeOfDay.now());
  final _dateWithoutTimeBehaviorSubject = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _unFocusKeyboardPublishSubject = PublishSubject<Unit>();
  late RestartableTimer _keyboardUnFocusTimer;

  //stream
  Stream<Option<Routine>> get routineBehaviorStream => _routineBehaviorSubject.asBroadcastStream();

  Stream<ReadingAndUnit> get bloodGlucoseReadingStream => _bloodGlucoseReading.asBroadcastStream();

  Stream<bool> get showHintText => _bloodGlucoseReading.map((event) => event.reading.isNone());

  Stream<TimeOfDay> get timeOfDayStream => _timeOfDayBehaviorSubject.asBroadcastStream();

  Stream<DateTime> get dateWithoutTimeStream => _dateWithoutTimeBehaviorSubject.asBroadcastStream();

  Stream<Unit> get unFocusKeyboardStream => _unFocusKeyboardPublishSubject.asBroadcastStream();

  Stream<Option<BloodGlucoseRating>> get bloodGlucoseRatingStream =>
      CombineLatestStream.combine2(_bloodGlucoseReading, _routineBehaviorSubject,
          (ReadingAndUnit reading, Option<Routine> routine) {
        return routine.fold(() => const None(), (a) => reading.getRatingOrNone(a));
      });

  //repository
  final _repo = GetIt.instance<BloodGlucoseReadingRepository>();
  final _unitService = GetIt.instance<UnitService>();
  late BloodGlucoseUnit _systemBloodGlucoseUnit;

  BloodGlucoseAddingViewModel(this.readingOrNone) {
    _systemBloodGlucoseUnit = _unitService.getBloodGlucoseUnit();
    readingOrNone.fold(
        () => _bloodGlucoseReading.add(ReadingAndUnit(
            const None(), //
            _unitService.getBloodGlucoseUnit())), (reading) {
      _routineBehaviorSubject.add(fromRoutineStringToEnum(reading.routine));
      _bloodGlucoseReading.add(ReadingAndUnit(
          Some(reading.getValueBySystemBloodGlucoseUnit(_systemBloodGlucoseUnit)), //
          _unitService.getBloodGlucoseUnit()));

      final date = reading.dateTime;
      _timeOfDayBehaviorSubject.add(TimeOfDay(hour: date.hour, minute: date.minute));
      _dateWithoutTimeBehaviorSubject.add(date);
    });

    _keyboardUnFocusTimer = RestartableTimer(const Duration(seconds: 3), () {
      if (_bloodGlucoseReading.value.reading.isSome()) {
        _unFocusKeyboardPublishSubject.add(unit);
      }
    });
  }

  void setBloodGlucoseReading(String text) {
    if (text.isEmpty) {
      _bloodGlucoseReading.add(ReadingAndUnit(const None(), _systemBloodGlucoseUnit));
    } else {
      _bloodGlucoseReading.add(ReadingAndUnit(optionOf(double.tryParse(text)), _systemBloodGlucoseUnit));
      _keyboardUnFocusTimer.reset(); //we reset the timer everytime user writes something
    }
  }

  bool isEditing() {
    return readingOrNone.isSome();
  }

  void setRoutine(Routine? v) {
    _routineBehaviorSubject.add(optionOf(v));
  }

  void setTimeOfDay(TimeOfDay v) {
    _timeOfDayBehaviorSubject.add(v);
  }

  void setDateWithoutTime(DateTime v) {
    _dateWithoutTimeBehaviorSubject.add(v);
  }

  Either<ErrorType, Unit> isFormValid() {
    if (_routineBehaviorSubject.value.isSome() && _bloodGlucoseReading.value.reading.isSome()) {
      return const Right(unit);
    } else {
      if (_routineBehaviorSubject.value.isNone()) {
        return const Left(ErrorType.kEmptyRoutine);
      } else {
        return const Left(ErrorType.kEmptyBloodGlucose);
      }
    }
  }

  addValue() async {
    await _bloodGlucoseReading.value.reading.fold(() => null, (reading) async {
      await _routineBehaviorSubject.value.fold(() => null, (routine) async {
        final dateWithoutTime = _dateWithoutTimeBehaviorSubject.value;
        final timeOfDay = _timeOfDayBehaviorSubject.value;

        final date = DateTime(
            dateWithoutTime.year, dateWithoutTime.month, dateWithoutTime.day, timeOfDay.hour, timeOfDay.minute);

        final value = BloodGlucoseReading.withNew(
            reading, //
            _systemBloodGlucoseUnit,
            routine,
            date,
            const None());
        await _repo.insert(value);
      });
    });
  }

  updateValue() async {
    await _bloodGlucoseReading.value.reading.fold(() => null, (reading) async {
      await _routineBehaviorSubject.value.fold(() => null, (routine) async {
        final dateWithoutTime = _dateWithoutTimeBehaviorSubject.value;
        final timeOfDay = _timeOfDayBehaviorSubject.value;

        final date = DateTime(
            dateWithoutTime.year, dateWithoutTime.month, dateWithoutTime.day, timeOfDay.hour, timeOfDay.minute);
        final newReading = BloodGlucoseReading.withNew(
            reading, //
            _systemBloodGlucoseUnit,
            routine,
            date,
            const None());

        await readingOrNone.fold(() => null, (a) async => await _repo.updateById(a.id, newReading));
      });
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
  }
}
