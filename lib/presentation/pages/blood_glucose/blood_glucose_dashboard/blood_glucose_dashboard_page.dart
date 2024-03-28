import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/presentation/constant.dart';
import 'package:healthtracker/presentation/widgets/blood_glucose_chart_card/blood_glucose_chart_card.dart';
import 'package:healthtracker/presentation/widgets/up_to_past_three_month_tab_bar.dart';

import 'blood_glucose_dashboard_page_view_model.dart';

class BloodGlucoseDashboardPage extends StatefulWidget {
  const BloodGlucoseDashboardPage({super.key});

  @override
  State<BloodGlucoseDashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<BloodGlucoseDashboardPage> {
  final BloodGlucoseDashboardPageViewModel _viewModel = BloodGlucoseDashboardPageViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.generateReadingSteam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bloodGlucose),
      ),
      body: SafeArea(
        child: Column(
          children: [
            DefaultTabController(
              length: 3,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(13))),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: UpToPastThreeMonthTabBar(),
                        ),
                      ),
                      SizedBox(
                        height: chartHeight,
                        child: StreamBuilder<BloodGlucoseStatisticBundle>(
                            stream: _viewModel.bloodGlucoseStatisticStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || snapshot.data == null) {
                                return const Text("Has error");
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TabBarView(
                                  children: [
                                    BloodGlucoseChartCard(snapshot.data!.lastWeekBloodGlucoseStatistic),
                                    BloodGlucoseChartCard(snapshot.data!.lastMonthBloodGlucoseStatistic),
                                    BloodGlucoseChartCard(snapshot.data!.lastThreeMonthBloodGlucoseStatistic)
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
