import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/services/language_service.dart';
import 'package:healthtracker/domain/value_objects/models.dart';

import 'package:shared_preferences/shared_preferences.dart';

const String LANGUAGE_OPTION_KEY = "language_option_key";

class SharedPreferenceLanguageService implements LanguageService {
  SharedPreferences? _preferences;

  @override
  LanguageOption get() {
    if (_preferences != null) {
      final locale = _preferences!.getString(LANGUAGE_OPTION_KEY) ?? "en";
      if (locale == 'en') {
        return LanguageOption.ENGLISH;
      } else if (locale == 'my') {
        return LanguageOption.MYANMAR;
      }
      return LanguageOption.ENGLISH;
    }
    return LanguageOption.ENGLISH;
  }

  @override
  Future<Unit> set(LanguageOption option) {
    if (_preferences != null) {
      switch (option) {
        case LanguageOption.ENGLISH:
          return _preferences!.setString(LANGUAGE_OPTION_KEY, 'en').then((value) => unit);
        case LanguageOption.MYANMAR:
          return _preferences!.setString(LANGUAGE_OPTION_KEY, 'my').then((value) => unit);
      }
    }
    return _preferences!.setString(LANGUAGE_OPTION_KEY, 'en').then((value) => unit);
  }

  @override
  Future<Unit> init() async {
    final f = await SharedPreferences.getInstance();
    _preferences = f;
    return unit;
  }
}
