import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/presentation/models/blood_glucose_models.dart';

import '../blood_glucose_line_chart.dart';
import 'blood_glucose_chart_card_view_model.dart';

class BloodGlucoseChartCard extends StatefulWidget {
  const BloodGlucoseChartCard(
    this._data, {
    Key? key,
  }) : super(key: key);

  final BloodGlucoseStatistic _data;

  @override
  State<BloodGlucoseChartCard> createState() => _BloodGlucoseChartCardState();
}

class _BloodGlucoseChartCardState extends State<BloodGlucoseChartCard> {
  late final BloodGlucoseDashboardPageViewModel _viewModel = BloodGlucoseDashboardPageViewModel(widget._data);

  List<DropdownMenuItem<String>> dropdownItems(BuildContext context) {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text(AppLocalizations.of(context)!.allPeriods), value: "ALL"),
      DropdownMenuItem(
          child: Text(
            AppLocalizations.of(context)!.beforeBreakfast,
          ),
          value: Routine.BEFORE_BREAKFAST.name),
      DropdownMenuItem(
          child: Text(AppLocalizations.of(context)!.afterBreakfast), value: Routine.AFTER_BREAKFAST.toString()),
      DropdownMenuItem(child: Text(AppLocalizations.of(context)!.beforeLunch), value: Routine.BEFORE_LUNCH.toString()),
      DropdownMenuItem(child: Text(AppLocalizations.of(context)!.afterLunch), value: Routine.AFTER_LUNCH.toString()),
      DropdownMenuItem(
          child: Text(AppLocalizations.of(context)!.beforeDinner), value: Routine.BEFORE_DINNER.toString()),
      DropdownMenuItem(child: Text(AppLocalizations.of(context)!.afterDinner), value: Routine.AFTER_DINNER.toString()),
      DropdownMenuItem(
          child: Text(AppLocalizations.of(context)!.justAfterWakeUp), value: Routine.JUST_AFTER_WAKE_UP.toString()),
      DropdownMenuItem(
          child: Text(AppLocalizations.of(context)!.justBeforeBedTime), value: Routine.JUST_BEFORE_BED_TIME.toString()),
      DropdownMenuItem(child: Text(AppLocalizations.of(context)!.otherRoutine), value: Routine.OTHER.toString()),
    ];
    return menuItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BloodGlucoseUnit unit = widget._data.systemBloodGlucoseUnit;

    return Card(
      child: Column(children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget._data.average.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.indigo),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(unit.toHumanReadable + " (${AppLocalizations.of(context)!.average})"),
                        )
                      ],
                      // );
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: StreamBuilder<String>(
                      stream: _viewModel.periodStringBehaviorStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError || snapshot.data == null) {
                          return const Text("Having error");
                        }

                        return DropdownButton(
                          value: snapshot.data!,
                          items: dropdownItems(context),
                          onChanged: (String? value) {
                            if (value != null) {
                              _viewModel.setPeriodAsText(value);
                            }
                          },
                        );
                      }),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: StreamBuilder<BloodGlucoseStatistic>(
                stream: _viewModel.bloodGlucoseStatisticsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Text("has error");
                  }
                  return BloodGlucoseLineChart(statistic: snapshot.data!);
                }),
          ),
        )
      ]),
    );
  }
}
