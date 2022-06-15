import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/domain/blood_pressure_calculator.dart';
import 'package:healthtracker/presentation/constant.dart';
import 'package:healthtracker/presentation/pages/blood_pressure/blood_pressure_adding_page/blood_pressure_adding_page.dart';
import 'package:healthtracker/presentation/pages/blood_pressure/blood_pressure_reading_list_page/blood_pressure_reading_list_view_model.dart';

class BloodPressureReadingListPage extends StatefulWidget {
  const BloodPressureReadingListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BloodPressureReadingListPage> createState() => _BloodPressureReadingListPageState();
}

class _BloodPressureReadingListPageState extends State<BloodPressureReadingListPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late BloodPressureReadingListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BloodPressureReadingListViewModel();
    _viewModel.generateReadingSteam();
  }

  @override
  Widget build(BuildContext context) {
    ///not to show keyboard after a widget is pressed
    FocusManager.instance.primaryFocus?.unfocus();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.textBloodPressure),
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.close),
          tooltip: 'Close',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: StreamBuilder<List<BloodGlucoseReadingByDateUI>>(
            stream: _viewModel.readingListBehaviorStream,
            builder: (context, snapshot) {
              if (snapshot.hasError || snapshot.data == null) {
                return const Text("Having error");
              }

              final readingList = snapshot.data!;

              if (readingList.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.youDontHaveAnyEntriesYet,
                        style: const TextStyle(fontSize: 18)));
              }

              return Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 8),
                child: ListView.builder(
                  itemCount: readingList.length,
                  itemBuilder: (context, index) {
                    final length = readingList[index].bloodGlucoseReadingUiList.length;

                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 2),
                        child: Column(
                          children: [
                                Container(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                        child:
                                            Text(readingList[index].dateAsString, style: const TextStyle(fontSize: 18)),
                                      )),
                                  color: softerPrimaryColor.withOpacity(0.5),
                                )
                              ] +
                              List.from(readingList[index]
                                  .bloodGlucoseReadingUiList
                                  .mapIndexed((index, e) => Container(
                                        child: BloodGlucoseReadingListItem(length != index + 1, e),
                                      ))
                                  .toList()),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}

class BloodGlucoseReadingListItem extends StatelessWidget {
  final BloodPressureReadingUi readingUi;
  final bool showDivider;

  const BloodGlucoseReadingListItem(
    this.showDivider,
    this.readingUi, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const width = 110.0;

    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BloodPressureAddingPage(dartz.Some(readingUi.reading))));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  SizedBox(
                      child: Text(AppLocalizations.of(context)!.period + " :", style: const TextStyle(fontSize: 18)),
                      width: width),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(child: Text(readingUi.timeOfDay, style: const TextStyle(fontSize: 18)), width: 90),
                  ])
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(children: [
                SizedBox(
                    child: Text(AppLocalizations.of(context)!.reading + " :", style: const TextStyle(fontSize: 18)),
                    width: width),
                Text("${readingUi.systolicReading}/${readingUi.diastolicReading} mmHg",
                    style: const TextStyle(fontSize: 18)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(children: [
                SizedBox(
                    child: Text(AppLocalizations.of(context)!.condition + " :", style: const TextStyle(fontSize: 18)),
                    width: width),
                readingUi.ratingOrNone.fold(
                    (l) => Text(AppLocalizations.of(context)!.unableToCalculate, style: const TextStyle(fontSize: 18)),
                    (r) => r.fold(
                            () => Text(AppLocalizations.of(context)!.unableToCalculate,
                                style: const TextStyle(fontSize: 18)), (a) {
                          switch (a) {
                            case BloodPressureRating.LOW_BLOOD_PRESSURE:
                              return Container(
                                color: Colors.purpleAccent,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.bloodPressureLow,
                                    style:
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              );

                            case BloodPressureRating.NORMAL:
                              return Container(
                                color: Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.bloodPressureNormal,
                                    style:
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              );
                            case BloodPressureRating.ELEVATED:
                              return Container(
                                color: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.bloodPressureElevated,
                                    style:
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              );
                            case BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_1:
                              return Container(
                                color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.bloodPressureHighStageOne,
                                    style:
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              );
                            case BloodPressureRating.HIGH_BLOOD_PRESSURE_STATE_2:
                              return Container(
                                color: Colors.deepOrange,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.bloodPressureHighStageTwo,
                                    style:
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              );
                            case BloodPressureRating.HYPERTENSIVE_CRISIS:
                              return Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.bloodPressureHypertensiveCrisis,
                                    style:
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              );
                          }
                        }))
              ]),
            ),
            showDivider
                ? const Divider(
                    color: Colors.black45,
                    thickness: 1,
                  )
                : const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: SizedBox.shrink(),
                  )
          ],
        ),
      ),
    );
  }
}
