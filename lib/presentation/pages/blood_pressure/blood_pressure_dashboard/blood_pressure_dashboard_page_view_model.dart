import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/repository/blood_pressure_reading_repository.dart';
import 'package:healthtracker/presentation/models/blood_pressure_model.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:rxdart/rxdart.dart';

class BloodPressureStatisticBundle {
  final BloodPressureReadingStatistic lastWeekBloodPressureStatistic;

  final BloodPressureReadingStatistic lastMonthBloodPressureStatistic;

  final BloodPressureReadingStatistic lastThreeMonthBloodPressureStatistic;

  BloodPressureStatisticBundle(
      {required this.lastWeekBloodPressureStatistic, //
      required this.lastMonthBloodPressureStatistic,
      required this.lastThreeMonthBloodPressureStatistic});
}

class BloodPressureDashboardPageViewModel extends ViewModel {
  // behavior subject
  final _bloodGlucoseStatisticBehaviorSubject = BehaviorSubject<BloodPressureStatisticBundle>();

  //stream
  Stream<BloodPressureStatisticBundle> get bloodPressureStatisticStream =>
      _bloodGlucoseStatisticBehaviorSubject.asBroadcastStream();

  //repository
  final _repo = GetIt.instance<BloodPressureReadingRepository>();

  void generateReadingSteam() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var last7Days = today.subtract(const Duration(days: 6));
    var last30Days = today.subtract(const Duration(days: 29));
    var last90Days = today.subtract(const Duration(days: 89));

    final last7DaysReadings = _repo.all.where((element) => element.dateTime.isAfter(last7Days)).toList();
    final last30DaysReadings = _repo.all.where((element) => element.dateTime.isAfter(last30Days)).toList();
    final last90DaysReadings = _repo.all.where((element) => element.dateTime.isAfter(last90Days)).toList();

    final r1 = BloodPressureReadingStatistic(last7DaysReadings, 7);
    final r2 = BloodPressureReadingStatistic(last30DaysReadings, 30);
    final r3 = BloodPressureReadingStatistic(last90DaysReadings, 90);
    _bloodGlucoseStatisticBehaviorSubject.add(BloodPressureStatisticBundle(
        lastWeekBloodPressureStatistic: r1,
        lastMonthBloodPressureStatistic: r2,
        lastThreeMonthBloodPressureStatistic: r3));
  }

  @override
  void dispose() {
    _bloodGlucoseStatisticBehaviorSubject.close();
  }
}
