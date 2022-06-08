import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/models/blood_pressure_reading.dart';
import 'package:healthtracker/domain/models/error.dart';

import 'hive_repository.dart';

abstract class BloodPressureReadingRepository implements HiveRepository {
  Either<RetrievedError, Option<BloodPressureReading>> getByTimestamp(String timestamp);

  Future<Either<RetrievedError, Unit>> insert(BloodPressureReading reading);

  Future<Either<RetrievedError, Unit>> updateById(String id, BloodPressureReading reading);

  Future<Either<RetrievedError, Unit>> deleteById(String id);

  Iterable<BloodPressureReading> get all;
}
