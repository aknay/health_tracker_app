import "package:collection/collection.dart";
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/models/blood_glucose_reading.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/domain/repository/blood_glucose_reading_repository.dart';
import 'package:healthtracker/domain/services/units_service.dart';
import 'package:healthtracker/presentation/pages/blood_glucose/blood_glucose_adding_page/blood_glucose_adding_view_model.dart';
import 'package:healthtracker/presentation/utils/string_helper.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class BloodGlucoseReadingUi {
  final BloodGlucoseReading reading;
  final BloodGlucoseUnit systemBloodGlucoseUnit;

  const BloodGlucoseReadingUi(this.reading, this.systemBloodGlucoseUnit);

  String get timeOfDay => _toFormattedTime(reading.dateTime);

  String get amount {
    final v = reading.getValueBySystemBloodGlucoseUnit(systemBloodGlucoseUnit);
    return getReadingByBloodGlucoseUnit(v, systemBloodGlucoseUnit);
  }

  Option<Routine> get period => fromRoutineStringToEnum(reading.routine);

  String get unit => systemBloodGlucoseUnit.toHumanReadable;

  DateTime get dateTimeWithoutTime {
    // this is for grouping by date without time
    return DateTime(reading.dateTime.year, reading.dateTime.month, reading.dateTime.day, 0, 0, 0);
  }

  int get timestamp => reading.dateTime.millisecondsSinceEpoch; // this is for sorting with timestamp

  String _toFormattedTime(DateTime dateTime) {
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dateTime);
  }

  Option<BloodGlucoseRating> get ratingOrNone => period.fold(
      () => const None(), (a) => ReadingAndUnit(Some(reading.value), systemBloodGlucoseUnit).getRatingOrNone(a));
}

class BloodGlucoseReadingByDateUI {
  final DateTime dateTime;
  final List<BloodGlucoseReadingUi> bloodGlucoseReadingUiList;

  const BloodGlucoseReadingByDateUI(this.dateTime, this.bloodGlucoseReadingUiList);

  String get dateAsString => _toFormattedDate(dateTime);

  String _toFormattedDate(DateTime time) {
    final DateFormat formatter = DateFormat('dd/MMM/yyyy');
    return formatter.format(time);
  }

  factory BloodGlucoseReadingByDateUI.fromBloodGlucoseReading(DateTime dateTime, List<BloodGlucoseReadingUi> v) {
    final f = List<BloodGlucoseReadingUi>.from(v);
    f.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return BloodGlucoseReadingByDateUI(dateTime, f);
  }
}

class BloodGlucoseReadingListViewModel extends ViewModel {
  // behavior subject
  final _routineBehaviorSubject = BehaviorSubject<Option<Routine>>.seeded(const None());
  final _readingListBehaviorSubject = BehaviorSubject<List<BloodGlucoseReadingByDateUI>>();

  //stream
  Stream<Option<Routine>> get routineBehaviorStream => _routineBehaviorSubject.asBroadcastStream();

  Stream<List<BloodGlucoseReadingByDateUI>> get readingListBehaviorStream =>
      _readingListBehaviorSubject.map((event) => event.toList()).asBroadcastStream();

  //repository
  final _repo = GetIt.instance<BloodGlucoseReadingRepository>();
  final _unitService = GetIt.instance<UnitService>();

  void generateReadingSteam() {
    final u = _unitService.getBloodGlucoseUnit();
    final v = _repo.all.map((e) => BloodGlucoseReadingUi(e, u)).toList();

    final groupByDate = groupBy(v, (BloodGlucoseReadingUi obj) => obj.dateTimeWithoutTime);

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
