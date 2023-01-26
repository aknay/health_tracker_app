import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/presentation/constant.dart';
import 'package:healthtracker/presentation/widgets/blood_pressure_chart_card.dart';
import 'package:healthtracker/presentation/widgets/up_to_past_three_month_tab_bar.dart';

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
        title: Text(AppLocalizations.of(context)!.textBloodPressure),
      ),
      body: SafeArea(
        child: Column(
          children: [
            DefaultTabController(
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
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
