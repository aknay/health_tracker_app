import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/domain/services/units_service.dart';
import 'package:healthtracker/presentation/view_model.dart';
import 'package:rxdart/rxdart.dart';


class UnitsPageViewModel extends ViewModel {
  final _service = GetIt.instance<UnitService>();
  final _bloodGlucoseUnitBehaviorSubject = BehaviorSubject<String>.seeded("");

  Stream<String> get bloodGlucoseUnitStream => _bloodGlucoseUnitBehaviorSubject.asBroadcastStream();

  UnitsPageViewModel() {
    _bloodGlucoseUnitBehaviorSubject.add(_service.getBloodGlucoseUnit().toHumanReadable);
  }

  Future<void> setUnit(BloodGlucoseUnit? v) async {
    await optionOf(v).fold(() => null, (a) async {
      await _service.setBloodGlucoseUnit(a);
      _bloodGlucoseUnitBehaviorSubject.add(_service.getBloodGlucoseUnit().toHumanReadable);
    });
  }

  @override
  void dispose() {
  }
}
