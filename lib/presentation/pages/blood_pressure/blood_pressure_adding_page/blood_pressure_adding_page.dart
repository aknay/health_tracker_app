import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/domain/blood_pressure_calculator.dart';
import 'package:healthtracker/domain/models/blood_pressure_reading.dart';
import 'package:healthtracker/presentation/pages/blood_pressure/blood_pressure_reading_list_page/blood_pressure_reading_list_page.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import 'blood_pressure_adding_view_model.dart';

class BloodPressureAddingPage extends StatefulWidget {
  final dartz.Option<BloodPressureReading> reading;

  const BloodPressureAddingPage(
    this.reading, {
    Key? key,
  }) : super(key: key);

  @override
  State<BloodPressureAddingPage> createState() => _BloodPressureAddingPageState();
}

class _BloodPressureAddingPageState extends State<BloodPressureAddingPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late BloodPressureAddingViewModel _viewModel;
  int _currentSystolicValue = 110;
  int _currentDiastolicValue = 70;

  @override
  void initState() {
    super.initState();
    widget.reading.fold(() => null, (a) {
      _currentSystolicValue = a.systolic;
      _currentDiastolicValue = a.diastolic;
    });
    _viewModel = BloodPressureAddingViewModel(widget.reading);
  }

  Future<void> _selectDate(BuildContext context, DateTime v) async {
    final DateTime? picked = await showDatePicker(
        locale: const Locale('en'),
        context: context,
        initialDate: v,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      _viewModel.setDateWithoutTime(picked);

      ///not to show keyboard after a widget is pressed
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay v) async {
    ///not to show keyboard after a widget is pressed
    FocusManager.instance.primaryFocus?.unfocus();
    final TimeOfDay? pickedTimeOfDay = await showTimePicker(
      context: context,
      initialTime: v,
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: child,
        );
      },
    );

    if (pickedTimeOfDay != null && pickedTimeOfDay != selectedTime) {
      _viewModel.setTimeOfDay(pickedTimeOfDay);
    }
  }

  String _toFormattedDate(DateTime time) {
    final DateFormat formatter = DateFormat('dd/MMM/yyyy');
    return formatter.format(time);
  }

  String _toFormattedTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    ///not to show keyboard after a widget is pressed
    FocusManager.instance.primaryFocus?.unfocus();
    final title = _viewModel.isEditing()
        ? AppLocalizations.of(context)!.editBloodGlucoseData
        : AppLocalizations.of(context)!.addBloodPressure;
    return Scaffold(
      resizeToAvoidBottomInset: false, //overlay keypad
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Column(children: [
            ListTile(
              title: Text(title, style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Divider(thickness: 1, color: Colors.black45),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.time, style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      StreamBuilder<DateTime>(
                          stream: _viewModel.dateWithoutTimeStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError || snapshot.data == null) {
                              return const Text("Having error");
                            }
                            return TextButton(
                              onPressed: () => _selectDate(context, snapshot.data!),
                              child: Text(_toFormattedDate(snapshot.data!), style: const TextStyle(fontSize: 18)),
                            );
                          }),
                      StreamBuilder<TimeOfDay>(
                          stream: _viewModel.timeOfDayStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError || snapshot.data == null) {
                              return const Text("Having error");
                            }
                            return TextButton(
                              onPressed: () => _selectTime(context, snapshot.data!),
                              child: Text(_toFormattedTime(snapshot.data!), style: const TextStyle(fontSize: 18)),
                            );
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(AppLocalizations.of(context)!.systolic, style: Theme.of(context).textTheme.headline6),
                            NumberPicker(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.black26),
                                ),
                                maxValue: 250,
                                minValue: 0,
                                onChanged: (value) {
                                  setState(() => _currentSystolicValue = value);
                                  _viewModel.setSystolicBloodPressure(value);
                                },
                                //we have to use this value as value of behavior subject is not that fast to update
                                value: _currentSystolicValue),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(AppLocalizations.of(context)!.diastolic, style: Theme.of(context).textTheme.headline6),
                          Row(
                            children: [
                              NumberPicker(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.black26)),
                                  maxValue: 250,
                                  minValue: 0,
                                  onChanged: (value) {
                                    setState(() => _currentDiastolicValue = value);
                                    _viewModel.setDiastolicBloodPressure(value);
                                  },
                                  value: _currentDiastolicValue),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 40, left: 8),
                        child: Text("mmHg"),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.condition, style: const TextStyle(fontSize: 18)),
                        const Spacer(),
                        StreamBuilder<dartz.Either<BloodPressureRatingError, dartz.Option<BloodPressureRating>>>(
                            stream: _viewModel.bloodGlucoseRatingStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || snapshot.data == null) {
                                return const Text("Having error");
                              }

                              final ratingOrError = snapshot.data!;

                              return ratingOrError.fold(
                                  (l) => Text(AppLocalizations.of(context)!.unableToCalculate,
                                      style: const TextStyle(fontSize: 18)),
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
                                                  style: const TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  style: const TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  style: const TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  style: const TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  style: const TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  style: const TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                                ),
                                              ),
                                            );
                                        }
                                      }));
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_viewModel.isFormValid().isLeft()) {
                      _viewModel.isFormValid().fold((l) {
                        switch (l) {
                          case BloodPressureRatingError.NOT_VALID:
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.errorEmptyRoutine,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            );
                            break;
                          case BloodPressureRatingError.SYSTOLIC_READING_SHOULD_BE_HIGHER_THAN_DIASTOLIC:
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.errorEmptyRoutine,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            );
                            break;
                          case BloodPressureRatingError.READING_TOO_LOW:
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.errorEmptyRoutine,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            );
                            break;
                        }
                      }, (r) {});
                    } else {
                      if (_viewModel.isEditing()) {
                        await _viewModel.updateValue();
                      } else {
                        await _viewModel.addValue();
                      }

                      if (_viewModel.isEditing()) {
                        Navigator.of(context).pop();
                        await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => //
                                    const BloodPressureReadingListPage()));
                      } else {
                        await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => //
                                    const BloodPressureReadingListPage()));
                      }
                    }
                  },
                  child: _viewModel.isEditing()
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.editButtonText, style: const TextStyle(fontSize: 18)),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.submitButtonText, style: const TextStyle(fontSize: 18)),
                        ),
                ),
              ),
            ),
            widget.reading.fold(
                () => const SizedBox.shrink(),
                (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                          onPressed: () async {
                            // set up the buttons
                            Widget cancelButton = TextButton(
                              child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(fontSize: 18)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                            Widget continueButton = TextButton(
                              child: Text(
                                AppLocalizations.of(context)!.deleteEntryButtonText,
                                style: const TextStyle(fontSize: 18),
                              ),
                              onPressed: () async {
                                final result = await _viewModel.deleteEntry();
                                result.fold((l) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(AppLocalizations.of(context)!.failToDelete,
                                              style: const TextStyle(fontSize: 18)),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(AppLocalizations.of(context)!.ok,
                                                  style: const TextStyle(fontSize: 18)),
                                            ),
                                          ],
                                        );
                                      });
                                }, (r) async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(AppLocalizations.of(context)!.successfullyDeleted,
                                            style: const TextStyle(fontSize: 18))),
                                  );

                                  Navigator.of(context)
                                    ..pop()
                                    ..pop();

                                  await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => //
                                              const BloodPressureReadingListPage()));
                                });
                              },
                            );

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              content: Text(AppLocalizations.of(context)!.areYouSureYouWantToDeleteThisRecord,
                                  style: const TextStyle(fontSize: 18)),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.deleteEntryButtonText,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    )),
          ]),
        ),
      ),
    );
  }
}
