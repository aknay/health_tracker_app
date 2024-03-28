import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/presentation/models/blood_glucose_models.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:rxdart/rxdart.dart';

class BloodGlucoseDashboardPageViewModel extends ViewModel {
  final BloodGlucoseStatistic _data;
  final _periodStringBehaviorSubject = BehaviorSubject<String>.seeded("ALL");
  final _bloodGlucoseStatisticBehaviorSubject = BehaviorSubject<BloodGlucoseStatistic>();

  Stream<String> get periodStringBehaviorStream => _periodStringBehaviorSubject.asBroadcastStream();

  Stream<BloodGlucoseStatistic> get bloodGlucoseStatisticsStream =>
      _bloodGlucoseStatisticBehaviorSubject.asBroadcastStream();

  BloodGlucoseDashboardPageViewModel(this._data) {
    _bloodGlucoseStatisticBehaviorSubject.add(_data);

    _periodStringBehaviorSubject.listen((value) {
      fromRoutineStringToEnum(value).fold(() {
        ///None mean Period (All has been selected)
        _bloodGlucoseStatisticBehaviorSubject.add(_data);
      }, (a) {
        final v = _data.reading.where((element) => element.routine == value).toList();
        final b = BloodGlucoseStatistic(v, _data.systemBloodGlucoseUnit, _data.dayCount);
        _bloodGlucoseStatisticBehaviorSubject.add(b);
      });
    });
  }

  @override
  void dispose() {
  }

  void setPeriodAsText(String v) {
    _periodStringBehaviorSubject.add(v);
  }
}
