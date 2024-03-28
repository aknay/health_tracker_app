import 'dart:developer';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/presentation/ads/ads_helper.dart';
import 'package:healthtracker/presentation/constant.dart';
import 'package:healthtracker/presentation/models/blood_glucose_models.dart';
import 'package:healthtracker/presentation/models/blood_pressure_model.dart';
import 'package:healthtracker/presentation/pages/blood_glucose/blood_glucose_adding_page/blood_glucose_adding_page.dart';
import 'package:healthtracker/presentation/pages/blood_glucose/blood_glucose_dashboard/blood_glucose_dashboard_page.dart';
import 'package:healthtracker/presentation/pages/blood_pressure/blood_pressure_adding_page/blood_pressure_adding_page.dart';
import 'package:healthtracker/presentation/pages/blood_pressure/blood_pressure_dashboard/blood_pressure_dashboard_page.dart';
import 'package:healthtracker/presentation/widgets/blood_glucose_line_chart.dart';
import 'package:healthtracker/presentation/widgets/blood_pressure_line_chart.dart';
import 'package:healthtracker/presentation/widgets/indicator.dart';

import 'dashboard_page_view_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  final DashboardPageViewModel _viewModel = DashboardPageViewModel();

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          log('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    _viewModel.generateReadingSteam();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: Offset.zero,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: 1,
          child: SpeedDial(
            activeIcon: Icons.close,
            icon: Icons.add,
            animatedIconTheme: const IconThemeData(size: 28.0),
            backgroundColor: primaryColor,
            visible: true,
            curve: Curves.bounceInOut,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.create, color: Colors.white),
                backgroundColor: primaryColor,
                onTap: () {
                  Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const BloodGlucoseAddingPage(dartz.None())))
                      .then((value) => _viewModel.generateReadingSteam());
                },
                label: AppLocalizations.of(context)!.addBloodGlucose,
                labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18),
                labelBackgroundColor: Colors.black,
              ),
              // SpeedDialChild(
              //   child: const Icon(Icons.create, color: Colors.white),
              //   backgroundColor: Colors.green,
              //   onTap: () => print('Pressed Write'),
              //   label: AppLocalizations.of(context)!.addWeight,
              //   labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              //   labelBackgroundColor: Colors.black,
              // ),
              SpeedDialChild(
                child: const Icon(Icons.compress, color: Colors.white),
                backgroundColor: primaryColor,
                onTap: () {
                  Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const BloodPressureAddingPage(dartz.None())))
                      .then((value) => _viewModel.generateReadingSteam());
                },
                label: AppLocalizations.of(context)!.addBloodPressure,
                labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18),
                labelBackgroundColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isBannerAdReady
                ? SizedBox(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodGlucoseDashboardPage()));
                },
                child: SizedBox(
                  height: chartHeight,
                  child: Card(
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.bloodGlucose,
                                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                Text("${AppLocalizations.of(context)!.past7DaysSingleLineDashBoard}  |  ${AppLocalizations.of(context)!.allPeriods}"),
                                StreamBuilder<BloodGlucoseStatistic>(
                                    stream: _viewModel.bloodGlucoseStatisticStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError || snapshot.data == null) {
                                        return const Text("Has error");
                                      }
                                      BloodGlucoseUnit unit = snapshot.data!.systemBloodGlucoseUnit;
                                      return Row(
                                        children: [
                                          Text(
                                            snapshot.data!.average.toStringAsFixed(1),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 32, color: Colors.indigo),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 2),
                                            child: Text(
                                                "${unit.toHumanReadable} (${AppLocalizations.of(context)!.average})"),
                                          )
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(Icons.arrow_forward_ios_outlined, size: 14.0),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder<BloodGlucoseStatistic>(
                            stream: _viewModel.bloodGlucoseStatisticStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || snapshot.data == null) {
                                return const Text("Has error");
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: BloodGlucoseLineChart(statistic: snapshot.data!),
                              );
                            }),
                      )
                    ]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodPressureDashboardPage()));
                },
                child: SizedBox(
                  height: chartHeight,
                  child: Card(
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.textBloodPressure,
                                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                Text(AppLocalizations.of(context)!.past7DaysSingleLineDashBoard),
                                StreamBuilder<BloodPressureReadingStatistic>(
                                    stream: _viewModel.bloodPressureStatisticStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError || snapshot.data == null) {
                                        return const Text("Has error");
                                      }
                                      return Row(
                                        children: [
                                          Text(
                                            "${snapshot.data!.systolicAverage.toStringAsFixed(0)}/${snapshot.data!.diastolicAverage.toStringAsFixed(0)}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 32, color: Colors.indigo),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 2),
                                            child: Text("mmHg (${AppLocalizations.of(context)!.average})"),
                                          )
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(Icons.arrow_forward_ios_outlined, size: 14.0),
                            ),
                          )
                        ],
                      ),
                      Expanded(

                        child: StreamBuilder<BloodPressureReadingStatistic>(
                            stream: _viewModel.bloodPressureStatisticStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || snapshot.data == null) {
                                return const Text("Has error");
                              }
                              return Padding(
                                padding: const EdgeInsets.only(left: 24, right: 8, bottom: 8),
                                child: BloodPressureLineChart(statistic: snapshot.data!),
                              );
                            }),
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100)

            ///add this padding so that floating action cannot block the chart
          ],
        ),
      ),
    );
  }
}
