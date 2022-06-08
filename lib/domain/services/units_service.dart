import 'package:dartz/dartz.dart';

import '../models/enums.dart';

abstract class UnitService {
  Future<Unit> setBloodGlucoseUnit(BloodGlucoseUnit option);

  BloodGlucoseUnit getBloodGlucoseUnit();

  Future<Unit> init();
}
