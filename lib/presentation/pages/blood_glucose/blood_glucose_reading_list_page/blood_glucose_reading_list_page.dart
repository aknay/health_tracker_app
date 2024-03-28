import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/presentation/constant.dart';
import 'package:healthtracker/presentation/pages/blood_glucose/blood_glucose_adding_page/blood_glucose_adding_page.dart';
import 'package:healthtracker/presentation/pages/blood_glucose/blood_glucose_adding_page/blood_glucose_adding_view_model.dart';

import 'blood_glucose_reading_list_view_model.dart';

class BloodGlucoseReadingListPage extends StatefulWidget {
  const BloodGlucoseReadingListPage({
    super.key,
  });

  @override
  State<BloodGlucoseReadingListPage> createState() => _BloodGlucoseReadingListPageState();
}

class _BloodGlucoseReadingListPageState extends State<BloodGlucoseReadingListPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late BloodGlucoseReadingListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BloodGlucoseReadingListViewModel();
    _viewModel.generateReadingSteam();
  }

  @override
  Widget build(BuildContext context) {
    ///not to show keyboard after a widget is pressed
    FocusManager.instance.primaryFocus?.unfocus();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bloodGlucose),
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
                                  color: softerPrimaryColor.withOpacity(0.5),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                        child:
                                            Text(readingList[index].dateAsString, style: const TextStyle(fontSize: 18)),
                                      )),
                                )
                              ] +
                              List.from(readingList[index]
                                  .bloodGlucoseReadingUiList
                                  .mapIndexed((index, e) => BloodGlucoseReadingListItem(length != index + 1, e))
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
  final BloodGlucoseReadingUi readingUi;
  final bool showDivider;

  const BloodGlucoseReadingListItem(
    this.showDivider,
    this.readingUi, {
    super.key,
  });

  String _fromRoutineToText(dartz.Option<Routine> v, context) {
    return v.fold(() => "", (a) {
      switch (a) {
        case Routine.kJustAfterWakeUp:
          return AppLocalizations.of(context)!.justAfterWakeUp;
        case Routine.kBeforeBreakfast:
          return AppLocalizations.of(context)!.beforeBreakfast;
        case Routine.kAfterBreakfast:
          return AppLocalizations.of(context)!.afterBreakfast;
        case Routine.kBeforeLunch:
          return AppLocalizations.of(context)!.beforeLunch;
        case Routine.kAfterLunch:
          return AppLocalizations.of(context)!.afterLunch;
        case Routine.kBeforeDinner:
          return AppLocalizations.of(context)!.beforeDinner;
        case Routine.kAfterDinner:
          return AppLocalizations.of(context)!.afterDinner;
        case Routine.kJustBeforeBedTime:
          return AppLocalizations.of(context)!.justBeforeBedTime;
        case Routine.kOther:
          return AppLocalizations.of(context)!.otherRoutine;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const width = 110.0;

    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BloodGlucoseAddingPage(dartz.Some(readingUi.reading))));
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
                      width: width,
                      child: Text("${AppLocalizations.of(context)!.period} :", style: const TextStyle(fontSize: 18))),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 90, child: Text(readingUi.timeOfDay, style: const TextStyle(fontSize: 18))),
                    Text(_fromRoutineToText(readingUi.period, context), style: const TextStyle(fontSize: 18))
                  ])
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(children: [
                SizedBox(
                    width: width,
                    child: Text("${AppLocalizations.of(context)!.reading} :", style: const TextStyle(fontSize: 18))),
                Text("${readingUi.amount} ${readingUi.unit}", style: const TextStyle(fontSize: 18)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(children: [
                SizedBox(
                    width: width,
                    child: Text("${AppLocalizations.of(context)!.condition} :", style: const TextStyle(fontSize: 18))),

                /// need to make a widget
                readingUi.ratingOrNone.fold(
                    () => Text(AppLocalizations.of(context)!.unableToCalculate, style: const TextStyle(fontSize: 18)),
                    (a) {
                  switch (a) {
                    case BloodGlucoseRating.kExcellent:
                      return Container(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(AppLocalizations.of(context)!.excellent,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      );
                    case BloodGlucoseRating.kGood:
                      return Container(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(AppLocalizations.of(context)!.good,
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                          ));

                    case BloodGlucoseRating.kAcceptable:
                      return Container(
                          color: Colors.yellow,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(AppLocalizations.of(context)!.acceptable,
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                          ));

                    case BloodGlucoseRating.kPoor:
                      return Container(
                          color: Colors.redAccent,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(AppLocalizations.of(context)!.poor,
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                          ));
                  }
                }),
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
