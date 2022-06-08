import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/domain/models/blood_glucose_reading.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/presentation/constant.dart';
import 'package:healthtracker/presentation/dialogs/change_period_dialog.dart';
import 'package:healthtracker/presentation/pages/blood_glucose/blood_glucose_reading_list_page/blood_glucose_reading_list_page.dart';
import 'package:intl/intl.dart';

import 'blood_glucose_adding_view_model.dart';

class BloodGlucoseAddingPage extends StatefulWidget {
  final dartz.Option<BloodGlucoseReading> reading;

  const BloodGlucoseAddingPage(
    this.reading, {
    Key? key,
  }) : super(key: key);

  @override
  State<BloodGlucoseAddingPage> createState() => _BloodGlucoseAddingPageState();
}

class _BloodGlucoseAddingPageState extends State<BloodGlucoseAddingPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  late BloodGlucoseAddingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BloodGlucoseAddingViewModel(widget.reading);
    _viewModel.unFocusKeyboardStream.listen((event) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
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
        : AppLocalizations.of(context)!.addBloodGlucoseData;
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
                    children: [
                      Text(AppLocalizations.of(context)!.period, style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(backgroundColor: primaryColor, primary: Colors.white),
                        onPressed: () async {
                          Routine? v = await showDialog(
                              context: context,
                              builder: (context) {
                                return const ChangePeriodDialog();
                              });
                          _viewModel.setRoutine(v);

                          ///not to show keyboard after a widget is pressed
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: StreamBuilder<dartz.Option<Routine>>(
                            stream: _viewModel.routineBehaviorStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || snapshot.data == null || snapshot.data!.isNone()) {
                                return Text(AppLocalizations.of(context)!.select, style: const TextStyle(fontSize: 18));
                              }
                              return snapshot.data!.fold(
                                  () =>
                                      Text(AppLocalizations.of(context)!.select, style: const TextStyle(fontSize: 18)),
                                  (a) {
                                switch (a) {
                                  case Routine.JUST_AFTER_WAKE_UP:
                                    return Text(AppLocalizations.of(context)!.justAfterWakeUp,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.BEFORE_BREAKFAST:
                                    return Text(AppLocalizations.of(context)!.beforeBreakfast,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.AFTER_BREAKFAST:
                                    return Text(AppLocalizations.of(context)!.afterBreakfast,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.BEFORE_LUNCH:
                                    return Text(AppLocalizations.of(context)!.beforeLunch,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.AFTER_LUNCH:
                                    return Text(AppLocalizations.of(context)!.afterLunch,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.BEFORE_DINNER:
                                    return Text(AppLocalizations.of(context)!.beforeDinner,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.AFTER_DINNER:
                                    return Text(AppLocalizations.of(context)!.afterDinner,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.JUST_BEFORE_BED_TIME:
                                    return Text(AppLocalizations.of(context)!.justBeforeBedTime,
                                        style: const TextStyle(fontSize: 18));
                                  case Routine.OTHER:
                                    return Text(AppLocalizations.of(context)!.otherRoutine,
                                        style: const TextStyle(fontSize: 18));
                                }
                              });
                            }),
                      )
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(AppLocalizations.of(context)!.bloodGlucose, style: const TextStyle(fontSize: 18)),
                            const Spacer(),
                            SizedBox(
                              width: 200,
                              child: StreamBuilder<ReadingAndUnit>(
                                  stream: _viewModel.bloodGlucoseReadingStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError || snapshot.data == null) {
                                      return const Text("Having error");
                                    }

                                    return TextFormField(
                                      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
                                      keyboardType: const TextInputType.numberWithOptions(
                                        decimal: true,
                                        signed: false,
                                      ),
                                      initialValue: snapshot.data!.readingAsText,
                                      maxLength: 4,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
                                      onChanged: (text) => _viewModel.setBloodGlucoseReading(text),
                                      decoration: InputDecoration(
                                        label: StreamBuilder<bool>(
                                            stream: _viewModel.showHintText,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError || snapshot.data == null) {
                                                return const Text("Having error");
                                              }

                                              final showHintText = snapshot.data!;

                                              return showHintText
                                                  ? Text(
                                                      AppLocalizations.of(context)!.enterValue,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                          backgroundColor: primaryColor,
                                                          color: Colors.white),
                                                    )
                                                  : const Text("");
                                            }),
                                        isDense: true,
                                        suffixIcon:
                                            Text(snapshot.data!.unitAsText, style: const TextStyle(fontSize: 18)),
                                        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                      ),
                                      textAlign: TextAlign.right,
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.condition, style: const TextStyle(fontSize: 18)),
                        const Spacer(),
                        StreamBuilder<dartz.Option<BloodGlucoseRating>>(
                            stream: _viewModel.bloodGlucoseRatingStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || snapshot.data == null) {
                                return const Text("Having error");
                              }

                              final ratingOrNone = snapshot.data!;

                              return ratingOrNone.fold(
                                  () => Text(AppLocalizations.of(context)!.unableToCalculate,
                                      style: const TextStyle(fontSize: 18)), (a) {
                                switch (a) {
                                  case BloodGlucoseRating.EXCELLENT:
                                    return Container(
                                      color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Text(AppLocalizations.of(context)!.excellent,
                                            style: const TextStyle(
                                                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                      ),
                                    );
                                  case BloodGlucoseRating.GOOD:
                                    return Container(
                                      color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Text(AppLocalizations.of(context)!.good,
                                            style: const TextStyle(
                                                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                      ),
                                    );

                                  case BloodGlucoseRating.ACCEPTABLE:
                                    return Container(
                                      color: Colors.yellow,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Text(AppLocalizations.of(context)!.acceptable,
                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      ),
                                    );

                                  case BloodGlucoseRating.POOR:
                                    return Container(
                                      color: Colors.redAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Text(AppLocalizations.of(context)!.poor,
                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      ),
                                    );
                                }
                              });
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
                          case ErrorType.EMPTY_ROUTINE:
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.errorEmptyRoutine,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            );
                            break;
                          case ErrorType.EMPTY_BLOOD_GLUCOSE:
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.errorEmptyBloodGlucose,
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
                                    const BloodGlucoseReadingListPage()));
                      } else {
                        await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => //
                                    const BloodGlucoseReadingListPage()));
                      }
                    }
                  },
                  child: _viewModel.isEditing()
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.edit, style: const TextStyle(fontSize: 18)),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.submit, style: const TextStyle(fontSize: 18)),
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
                                AppLocalizations.of(context)!.deleteEntry,
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
                                              const BloodGlucoseReadingListPage()));
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
                              AppLocalizations.of(context)!.deleteEntry,
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
