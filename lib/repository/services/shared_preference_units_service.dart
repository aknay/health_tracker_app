import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/enums.dart';
import '../../domain/services/units_service.dart';

const String kBloodGlucoseUnitKey = "blood_glucose_unit_key";

class SharedPreferenceUnitService implements UnitService {
  SharedPreferences? _preferences;

  @override
  BloodGlucoseUnit getBloodGlucoseUnit() {
    if (_preferences != null) {
      final locale = _preferences!.getString(kBloodGlucoseUnitKey) ?? BloodGlucoseUnit.kMgDividedByDl.toString();

      final values = BloodGlucoseUnit.values.where((element) => element.toString() == locale);

      if (values.isEmpty) {
        return BloodGlucoseUnit.kMgDividedByDl; //as default
      }
      return values.first;
    }
    return BloodGlucoseUnit.kMgDividedByDl; //as default
  }

  @override
  Future<Unit> setBloodGlucoseUnit(BloodGlucoseUnit option) {
    return _preferences!.setString(kBloodGlucoseUnitKey, option.toString()).then((value) => unit);
  }

  @override
  Future<Unit> init() async {
    final f = await SharedPreferences.getInstance();
    _preferences = f;
    return unit;
  }
}
