import 'package:dartz/dartz.dart';
import 'package:healthtracker/domain/services/language_service.dart';
import 'package:healthtracker/domain/value_objects/models.dart';

import 'package:shared_preferences/shared_preferences.dart';

const String kLanguageOptionKey = "language_option_key";

class SharedPreferenceLanguageService implements LanguageService {
  SharedPreferences? _preferences;

  @override
  LanguageOption get() {
    if (_preferences != null) {
      final locale = _preferences!.getString(kLanguageOptionKey) ?? "en";
      if (locale == 'en') {
        return LanguageOption.kEnglish;
      } else if (locale == 'my') {
        return LanguageOption.kMyanmar;
      }
      return LanguageOption.kEnglish;
    }
    return LanguageOption.kEnglish;
  }

  @override
  Future<Unit> set(LanguageOption option) {
    if (_preferences != null) {
      switch (option) {
        case LanguageOption.kEnglish:
          return _preferences!.setString(kLanguageOptionKey, 'en').then((value) => unit);
        case LanguageOption.kMyanmar:
          return _preferences!.setString(kLanguageOptionKey, 'my').then((value) => unit);
      }
    }
    return _preferences!.setString(kLanguageOptionKey, 'en').then((value) => unit);
  }

  @override
  Future<Unit> init() async {
    final f = await SharedPreferences.getInstance();
    _preferences = f;
    return unit;
  }
}
