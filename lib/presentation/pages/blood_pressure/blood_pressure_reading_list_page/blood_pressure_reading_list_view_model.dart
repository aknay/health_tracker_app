import "package:collection/collection.dart";
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/blood_pressure_calculator.dart';
import 'package:healthtracker/domain/models/blood_pressure_reading.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/domain/repository/blood_pressure_reading_repository.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class BloodPressureReadingUi {
  final BloodPressureReading reading;

  const BloodPressureReadingUi(this.reading);

  String get timeOfDay => _toFormattedTime(reading.dateTime);

  String get systolicReading => reading.systolic.toString();

  String get diastolicReading => reading.diastolic.toString();

  DateTime get dateTimeWithoutTime {
    // this is for grouping by date without time
    return DateTime(reading.dateTime.year, reading.dateTime.month, reading.dateTime.day, 0, 0, 0);
  }

  int get timestamp => reading.dateTime.millisecondsSinceEpoch; // this is for sorting with timestamp

  String _toFormattedTime(DateTime dateTime) {
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dateTime);
  }

  Either<BloodPressureRatingError, Option<BloodPressureRating>> get ratingOrNone =>
      getBloodPressureRating(systolicReading: reading.systolic, diastolicReading: reading.diastolic);
}

class BloodGlucoseReadingByDateUI {
  final DateTime dateTime;
  final List<BloodPressureReadingUi> bloodGlucoseReadingUiList;

  const BloodGlucoseReadingByDateUI(this.dateTime, this.bloodGlucoseReadingUiList);

  String get dateAsString => _toFormattedDate(dateTime);

  String _toFormattedDate(DateTime time) {
    final DateFormat formatter = DateFormat('dd/MMM/yyyy');
    return formatter.format(time);
  }

  factory BloodGlucoseReadingByDateUI.fromBloodGlucoseReading(DateTime dateTime, List<BloodPressureReadingUi> v) {
    final f = List<BloodPressureReadingUi>.from(v);
    f.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return BloodGlucoseReadingByDateUI(dateTime, f);
  }
}

class BloodPressureReadingListViewModel extends ViewModel {
  // behavior subject
  final _routineBehaviorSubject = BehaviorSubject<Option<Routine>>.seeded(const None());
  final _readingListBehaviorSubject = BehaviorSubject<List<BloodGlucoseReadingByDateUI>>();

  //stream
  Stream<Option<Routine>> get routineBehaviorStream => _routineBehaviorSubject.asBroadcastStream();

  Stream<List<BloodGlucoseReadingByDateUI>> get readingListBehaviorStream =>
      _readingListBehaviorSubject.map((event) => event.toList()).asBroadcastStream();

  //repository
  final _repo = GetIt.instance<BloodPressureReadingRepository>();

  void generateReadingSteam() {
    final v = _repo.all.map((e) => BloodPressureReadingUi(e)).toList();

    final groupByDate = groupBy(v, (BloodPressureReadingUi obj) => obj.dateTimeWithoutTime);

    final bloodGlucoseReadingByDateUiList = groupByDate
        .map((key, value) => MapEntry(key, BloodGlucoseReadingByDateUI.fromBloodGlucoseReading(key, value)))
        .values
        .toList();

    bloodGlucoseReadingByDateUiList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    _readingListBehaviorSubject.add(bloodGlucoseReadingByDateUiList);
  }

  @override
  void dispose() {
  }
}
