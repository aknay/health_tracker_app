import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/repository/blood_glucose_reading_repository.dart';
import 'package:healthtracker/domain/repository/blood_pressure_reading_repository.dart';
import 'package:healthtracker/domain/services/units_service.dart';
import 'package:healthtracker/presentation/models/blood_glucose_models.dart';
import 'package:healthtracker/presentation/models/blood_pressure_model.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:rxdart/rxdart.dart';

class DashboardPageViewModel extends ViewModel {
  // behavior subject
  final _bloodGlucoseStatisticBehaviorSubject = BehaviorSubject<BloodGlucoseStatistic>();
  final _bloodPressureStatisticBehaviorSubject = BehaviorSubject<BloodPressureReadingStatistic>();

  //stream
  Stream<BloodGlucoseStatistic> get bloodGlucoseStatisticStream =>
      _bloodGlucoseStatisticBehaviorSubject.asBroadcastStream();

  Stream<BloodPressureReadingStatistic> get bloodPressureStatisticStream =>
      _bloodPressureStatisticBehaviorSubject.asBroadcastStream();

  //repository
  final _bloodGlucoseReadingRepo = GetIt.instance<BloodGlucoseReadingRepository>();
  final _bloodPressureReadingRepo = GetIt.instance<BloodPressureReadingRepository>();
  final _unitService = GetIt.instance<UnitService>();

  void generateReadingSteam() {
    final u = _unitService.getBloodGlucoseUnit();

    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var last7Days = today.subtract(const Duration(days: 6));

    final last7DaysBloodGlucoseReadings =
        _bloodGlucoseReadingRepo.all.where((element) => element.dateTime.isAfter(last7Days)).toList();

    final bloodGlucoseStatistic = BloodGlucoseStatistic(last7DaysBloodGlucoseReadings, u, 7);
    _bloodGlucoseStatisticBehaviorSubject.add(bloodGlucoseStatistic);

    final last7DaysBloodPressureReadings =
        _bloodPressureReadingRepo.all.where((element) => element.dateTime.isAfter(last7Days)).toList();

    final bloodPressureStatistic = BloodPressureReadingStatistic(last7DaysBloodPressureReadings, 7);
    _bloodPressureStatisticBehaviorSubject.add(bloodPressureStatistic);
  }

  @override
  void dispose() {
  }
}
