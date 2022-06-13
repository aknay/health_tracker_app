import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/presentation/widgets/blood_pressure_chart_card.dart';

import 'blood_pressure_dashboard_page_view_model.dart';

class BloodPressureDashboardPage extends StatefulWidget {
  const BloodPressureDashboardPage({Key? key}) : super(key: key);

  @override
  State<BloodPressureDashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<BloodPressureDashboardPage> {
  final BloodPressureDashboardPageViewModel _viewModel = BloodPressureDashboardPageViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.generateReadingSteam();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(13))),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.indigo,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(13), // Creates border
                                color: Colors.blue),
                            tabs: [
                              SizedBox(
                                  child: Tab(
                                      child: Text(
                                AppLocalizations.of(context)!.past7Days,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14, height: 1.5),
                              ))),
                              Tab(
                                child: Text(AppLocalizations.of(context)!.oneMonth,
                                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.5)),
                              ),
                              Tab(
                                child: Text(AppLocalizations.of(context)!.threeMonth,
                                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 255,
                        child: StreamBuilder<BloodPressureStatisticBundle>(
                            stream: _viewModel.bloodPressureStatisticStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || snapshot.data == null) {
                                return const Text("Has error");
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TabBarView(
                                  children: [
                                    BloodPressureChartCard(snapshot.data!.lastWeekBloodPressureStatistic),
                                    BloodPressureChartCard(snapshot.data!.lastMonthBloodPressureStatistic),
                                    BloodPressureChartCard(snapshot.data!.lastThreeMonthBloodPressureStatistic),
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
              length: 3,
            ),
          ],
        ),
      ),
    );
  }
}
