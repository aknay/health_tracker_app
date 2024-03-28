import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/models/blood_glucose_reading.dart';
import 'package:healthtracker/domain/models/error.dart';
import 'package:hive/hive.dart';


import '../domain/repository/blood_glucose_reading_repository.dart';

class BloodGlucoseReadingHiveRepository implements BloodGlucoseReadingRepository {
  late Box<BloodGlucoseReading> _box;

  @override
  Iterable<BloodGlucoseReading> get all => _box.values;

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
  Either<RetrievedError, Option<BloodGlucoseReading>> getByTimestamp(String timestamp) {
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
  Future<Either<RetrievedError, Unit>> insert(BloodGlucoseReading reading) async {
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
  Future<Either<RetrievedError, Unit>> updateById(String id, BloodGlucoseReading reading) async {
    if (!_box.containsKey(id)) {
      return left(RetrievedError("Unable to find the key"));
    }
    try {
      final r = BloodGlucoseReading.fromIdUpdate(id, reading);
      await _box.put(id, r);
      return right(unit);
    } catch (e) {
      return left(RetrievedError("Unable to update"));
    }
  }

  void _loadHiveRegisters() {
    Hive.registerAdapter(BloodGlucoseReadingAdapter());
  }

  Future _openKanjiCharacterBoxes() async {
    _box = await Hive.openBox<BloodGlucoseReading>(BloodGlucoseReading.tableName);
  }
}
