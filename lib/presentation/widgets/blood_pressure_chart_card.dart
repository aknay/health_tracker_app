import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/presentation/models/blood_pressure_model.dart';
import 'package:healthtracker/presentation/widgets/blood_pressure_line_chart.dart';
import 'package:healthtracker/presentation/widgets/indicator.dart';

class BloodPressureChartCard extends StatelessWidget {
  final BloodPressureReadingStatistic _statistic;

  const BloodPressureChartCard(
    this._statistic, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${_statistic.averageSystolicAsFixedPrecision}/${_statistic.averageDiastolicAsFixedPrecision} ",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.indigo),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text("mmHg (${AppLocalizations.of(context)!.average})"),
                      ),
                    ],
                  )
                  //     }),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 8, bottom: 8),
            child: BloodPressureLineChart(statistic: _statistic),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Indicator(color: const Color(0xff22ff00), text: AppLocalizations.of(context)!.systolic, isSquare: true),
              const SizedBox(width: 10),
              Indicator(color: Colors.blue, text: AppLocalizations.of(context)!.diastolic, isSquare: true),
            ],
          ),
        )
      ]),
    );
  }
}
