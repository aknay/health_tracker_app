import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/repository/blood_pressure_reading_repository.dart';
import 'package:healthtracker/presentation/constant.dart';
import 'package:healthtracker/presentation/pages/dashboard/dashboard_page.dart';
import 'package:healthtracker/presentation/pages/diary_page.dart';
import 'package:healthtracker/presentation/settings/settings.dart';
import 'package:healthtracker/repository/blood_glucose_reading_hive_repository.dart';
import 'package:healthtracker/repository/blood_pressure_reading_hive_repository.dart';
import 'package:healthtracker/repository/services/shared_preference_units_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'domain/repository/blood_glucose_reading_repository.dart';
import 'domain/services/language_service.dart';
import 'domain/services/units_service.dart';
import 'domain/value_objects/models.dart';
import 'repository/services/shared_preference_language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  final getIt = GetIt.instance;

  /// register for shared preference
  getIt.registerSingleton<LanguageService>(SharedPreferenceLanguageService());
  await GetIt.instance<LanguageService>().init();

  getIt.registerSingleton<UnitService>(SharedPreferenceUnitService());
  await GetIt.instance<UnitService>().init();

  ///
  getIt.registerSingleton<BloodGlucoseReadingRepository>(BloodGlucoseReadingHiveRepository());
  await getIt<BloodGlucoseReadingRepository>().loadDatabase();
  // await getIt<BloodGlucoseReadingRepository>().clearDatabase();

  getIt.registerSingleton<BloodPressureReadingRepository>(BloodPressureReadingHiveRepository());
  await getIt<BloodPressureReadingRepository>().loadDatabase();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      state.changeLanguage(newLocale);
    }
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;
  final _languageService = GetIt.instance<LanguageService>();

  @override
  void initState() {
    super.initState();
    final languageOption = _languageService.get();
    switch (languageOption) {
      case LanguageOption.ENGLISH:
        _locale = const Locale('en', '');
        break;
      case LanguageOption.MYANMAR:
        _locale = const Locale('my', '');
        break;
    }
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      title: 'Flutter Demo',
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('my', ''), // Spanish, no country code
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primarySwatch: createMaterialColor(primaryColor),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _pages = const [DashboardPage(), DiaryPage(), SettingsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titleList = [
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.statistics,
      AppLocalizations.of(context)!.more,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titleList[_selectedIndex]),
        ///disable for now
        // actions: [
        // PopupMenuButton(
        //     itemBuilder: (context) => [
        //           const PopupMenuItem(
        //             child: Text("Settings"),
        //             value: 1,
        //           ),
        //           const PopupMenuItem(
        //             child: Text("Share with Friends"),
        //             value: 2,
        //           )
        //         ])
        // ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 18,
        unselectedFontSize: 14,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            label: AppLocalizations.of(context)!.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dehaze),
            label: AppLocalizations.of(context)!.more,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // can't use IndexedStack as it will not change the states inside
          child: _pages.elementAt(_selectedIndex)),
    );
  }
}
