import 'package:dartz/dartz.dart';

abstract class HiveRepository {
  Future<Unit> loadDatabase();

  Future<Unit> clearDatabase();

  bool get isEmpty;
}
