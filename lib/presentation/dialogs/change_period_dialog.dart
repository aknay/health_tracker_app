import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/models/enums.dart';
import '../widgets/dialog/dialog_action_button.dart';
import '../widgets/dialog/dialog_title.dart';

class ChangePeriodDialog extends StatefulWidget {
  const ChangePeriodDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ChangePeriodDialogState createState() => _ChangePeriodDialogState();
}

class _ChangePeriodDialogState extends State<ChangePeriodDialog> {
  late Routine? _routine = Routine.BEFORE_BREAKFAST;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogTitle(AppLocalizations.of(context)!.period),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Routine>(
              title: Text(AppLocalizations.of(context)!.justAfterWakeUp),
              value: Routine.JUST_AFTER_WAKE_UP,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
            ),
            RadioListTile<Routine>(
              value: Routine.BEFORE_BREAKFAST,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.beforeBreakfast),
            ),
            RadioListTile<Routine>(
              value: Routine.AFTER_BREAKFAST,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.afterBreakfast),
            ),
            RadioListTile<Routine>(
              value: Routine.BEFORE_LUNCH,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.beforeLunch),
            ),
            RadioListTile<Routine>(
              value: Routine.AFTER_LUNCH,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.afterLunch),
            ),
            RadioListTile<Routine>(
              title: Text(AppLocalizations.of(context)!.beforeDinner),
              value: Routine.BEFORE_DINNER,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
            ),
            RadioListTile<Routine>(
              value: Routine.AFTER_DINNER,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.afterDinner),
            ),
            RadioListTile<Routine>(
              value: Routine.JUST_BEFORE_BED_TIME,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.justBeforeBedTime),
            ),
            RadioListTile<Routine>(
              value: Routine.OTHER,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.otherRoutine),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: DialogActionButton(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: DialogActionButton(AppLocalizations.of(context)!.ok),
          onPressed: () {
            Navigator.pop(context, _routine);
          },
        ),
      ],
    );
  }
}
