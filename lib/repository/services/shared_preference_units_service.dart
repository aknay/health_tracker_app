import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/enums.dart';
import '../../domain/services/units_service.dart';

const String BLOOD_GLUCOSE_UNIT_KEY = "blood_glucose_unit_key";

class SharedPreferenceUnitService implements UnitService {
  SharedPreferences? _preferences;

  @override
  BloodGlucoseUnit getBloodGlucoseUnit() {
    if (_preferences != null) {
      final locale = _preferences!.getString(BLOOD_GLUCOSE_UNIT_KEY) ?? BloodGlucoseUnit.MG_DIVIDED_BY_DL.toString();

      final values = BloodGlucoseUnit.values.where((element) => element.toString() == locale);

      if (values.isEmpty) {
        return BloodGlucoseUnit.MG_DIVIDED_BY_DL; //as default
      }
      return values.first;
    }
    return BloodGlucoseUnit.MG_DIVIDED_BY_DL; //as default
  }

  @override
  Future<Unit> setBloodGlucoseUnit(BloodGlucoseUnit option) {
    return _preferences!.setString(BLOOD_GLUCOSE_UNIT_KEY, option.toString()).then((value) => unit);
  }

  @override
  Future<Unit> init() async {
    final f = await SharedPreferences.getInstance();
    _preferences = f;
    return unit;
  }
}
