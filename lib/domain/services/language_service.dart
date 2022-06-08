import 'package:dartz/dartz.dart';

import '../value_objects/models.dart';

abstract class LanguageService {
  Future<Unit> set(LanguageOption option);

  LanguageOption get();

  Future<Unit> init();
}
