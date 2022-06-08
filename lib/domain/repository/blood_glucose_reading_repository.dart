import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/models/error.dart';

import '../models/blood_glucose_reading.dart';
import 'hive_repository.dart';

abstract class BloodGlucoseReadingRepository implements HiveRepository {
  Either<RetrievedError, Option<BloodGlucoseReading>> getByTimestamp(String id);

  Future<Either<RetrievedError, Unit>> insert(BloodGlucoseReading reading);

  Future<Either<RetrievedError, Unit>>  updateById(String id, BloodGlucoseReading reading);

  Future<Either<RetrievedError, Unit>> deleteById(String id);

  Iterable<BloodGlucoseReading> get all;
}
