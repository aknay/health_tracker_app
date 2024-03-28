import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/presentation/widgets/dialog/dialog_action_button.dart';
import 'package:healthtracker/presentation/widgets/dialog/dialog_title.dart';

class ChangePeriodDialog extends StatefulWidget {
  const ChangePeriodDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePeriodDialogState();
}

class _ChangePeriodDialogState extends State<ChangePeriodDialog> {
  late Routine? _routine = Routine.kBeforeBreakfast;

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
              value: Routine.kJustAfterWakeUp,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
            ),
            RadioListTile<Routine>(
              value: Routine.kBeforeBreakfast,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.beforeBreakfast),
            ),
            RadioListTile<Routine>(
              value: Routine.kAfterBreakfast,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.afterBreakfast),
            ),
            RadioListTile<Routine>(
              value: Routine.kBeforeLunch,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.beforeLunch),
            ),
            RadioListTile<Routine>(
              value: Routine.kAfterLunch,
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
              value: Routine.kBeforeDinner,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
            ),
            RadioListTile<Routine>(
              value: Routine.kAfterDinner,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.afterDinner),
            ),
            RadioListTile<Routine>(
              value: Routine.kJustBeforeBedTime,
              groupValue: _routine,
              onChanged: (Routine? value) {
                setState(() {
                  _routine = value;
                });
              },
              title: Text(AppLocalizations.of(context)!.justBeforeBedTime),
            ),
            RadioListTile<Routine>(
              value: Routine.kOther,
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
