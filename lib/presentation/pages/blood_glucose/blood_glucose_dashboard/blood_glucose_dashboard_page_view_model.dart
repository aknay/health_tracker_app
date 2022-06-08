import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/repository/blood_glucose_reading_repository.dart';
import 'package:healthtracker/domain/services/units_service.dart';
import 'package:healthtracker/presentation/models/blood_glucose_models.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:rxdart/rxdart.dart';

class BloodGlucoseStatisticBundle {
  final BloodGlucoseStatistic lastWeekBloodGlucoseStatistic;

  final BloodGlucoseStatistic lastMonthBloodGlucoseStatistic;

  final BloodGlucoseStatistic lastThreeMonthBloodGlucoseStatistic;

  BloodGlucoseStatisticBundle(
      {required this.lastWeekBloodGlucoseStatistic, //
      required this.lastMonthBloodGlucoseStatistic,
      required this.lastThreeMonthBloodGlucoseStatistic});
}

class BloodGlucoseDashboardPageViewModel extends ViewModel {
  // behavior subject
  final _bloodGlucoseStatisticBehaviorSubject = BehaviorSubject<BloodGlucoseStatisticBundle>();

  //stream
  Stream<BloodGlucoseStatisticBundle> get bloodGlucoseStatisticStream =>
      _bloodGlucoseStatisticBehaviorSubject.asBroadcastStream();

  //repository
  final _repo = GetIt.instance<BloodGlucoseReadingRepository>();
  final _unitService = GetIt.instance<UnitService>();

  void generateReadingSteam() {
    final u = _unitService.getBloodGlucoseUnit();

    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var last7Days = today.subtract(const Duration(days: 6));
    var last30Days = today.subtract(const Duration(days: 29));
    var last90Days = today.subtract(const Duration(days: 89));

    final last7DaysReadings = _repo.all.where((element) => element.dateTime.isAfter(last7Days)).toList();
    final last30DaysReadings = _repo.all.where((element) => element.dateTime.isAfter(last30Days)).toList();
    final last90DaysReadings = _repo.all.where((element) => element.dateTime.isAfter(last90Days)).toList();

    final r1 = BloodGlucoseStatistic(last7DaysReadings, u, 7);
    final r2 = BloodGlucoseStatistic(last30DaysReadings, u, 30);
    final r3 = BloodGlucoseStatistic(last90DaysReadings, u, 90);
    _bloodGlucoseStatisticBehaviorSubject.add(BloodGlucoseStatisticBundle(
        lastWeekBloodGlucoseStatistic: r1,
        lastMonthBloodGlucoseStatistic: r2,
        lastThreeMonthBloodGlucoseStatistic: r3));
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
