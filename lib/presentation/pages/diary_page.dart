import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/presentation/pages/blood_glucose/blood_glucose_reading_list_page/blood_glucose_reading_list_page.dart';
import 'package:healthtracker/presentation/pages/blood_pressure/blood_pressure_reading_list_page/blood_pressure_reading_list_page.dart';


class DiaryPage extends StatelessWidget {
  const DiaryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => //
                          const BloodGlucoseReadingListPage()));
            },
            child: Card(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 100,
                    child: Image.asset("assets/glucose-meter.png"),
                  ),
                ),
                Text(AppLocalizations.of(context)!.cardBloodGlucose, style: const TextStyle(fontSize: 18),)
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => //
                      const BloodPressureReadingListPage()));
            },
            child: Card(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 100,
                    child: Image.asset("assets/blood-pressure.png"),
                  ),
                ),
                Text(AppLocalizations.of(context)!.textBloodPressure, style: const TextStyle(fontSize: 18),)
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
