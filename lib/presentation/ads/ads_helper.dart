import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    //load production ads when on release mode, if not we load test ads
    return kReleaseMode ? 'ca-app-pub-6807797470193781/4128322780' : 'ca-app-pub-3940256099942544/6300978111';
  }
}
