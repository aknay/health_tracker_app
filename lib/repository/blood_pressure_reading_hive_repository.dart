import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/models/blood_pressure_reading.dart';
import 'package:healthtracker/domain/models/error.dart';
import 'package:healthtracker/domain/repository/blood_pressure_reading_repository.dart';
import 'package:hive/hive.dart';

class BloodPressureReadingHiveRepository implements BloodPressureReadingRepository {
  late Box<BloodPressureReading> _box;

  @override
  Iterable<BloodPressureReading> get all => _box.values;

  @override
  Future<Unit> clearDatabase() async {
    await _box.clear();
    return unit;
  }

  @override
  Future<Either<RetrievedError, Unit>> deleteById(String timestamp) async {
    if (!_box.containsKey(timestamp)) {
      return left(RetrievedError("Unable to find the key"));
    }
    try {
      await _box.delete(timestamp);
      return right(unit);
    } catch (e) {
      return left(RetrievedError("Having error"));
    }
  }

  @override
  Either<RetrievedError, Option<BloodPressureReading>> getByTimestamp(String timestamp) {
    try {
      if (!_box.containsKey(timestamp)) {
        return right(none());
      }

      final value = _box.get(timestamp);
      if (value == null) {
        return left(RetrievedError("Unable to find the element with the key"));
      }
      return right(Some(value));
    } catch (e) {
      return left(RetrievedError("Having retrieve error"));
    }
  }

  @override
  Future<Either<RetrievedError, Unit>> insert(BloodPressureReading reading) async {
    try {
      await _box.put(reading.id, reading);
      return right(unit);
    } catch (e) {
      return left(RetrievedError("Unable to insert$e"));
    }
  }

  @override
  bool get isEmpty => _box.isEmpty;

  @override
  Future<Unit> loadDatabase() async {
    _loadHiveRegisters();
    await _openKanjiCharacterBoxes();
    return unit;
  }

  @override
  Future<Either<RetrievedError, Unit>> updateById(String id, BloodPressureReading reading) async {
    if (!_box.containsKey(id)) {
      return left(RetrievedError("Unable to find the key"));
    }
    try {
      final r = BloodPressureReading.fromIdUpdate(id, reading);
      await _box.put(id, r);
      return right(unit);
    } catch (e) {
      return left(RetrievedError("Unable to update"));
    }
  }

  void _loadHiveRegisters() {
    Hive.registerAdapter(BloodPressureReadingAdapter());
  }

  Future _openKanjiCharacterBoxes() async {
    _box = await Hive.openBox<BloodPressureReading>(BloodPressureReading.tableName);
  }

  Either<RetrievedError, Unit> update(BloodPressureReading reading) {
    throw UnimplementedError();
  }
}
