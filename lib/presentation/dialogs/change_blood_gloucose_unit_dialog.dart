import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/domain/services/units_service.dart';
import 'package:healthtracker/presentation/widgets/dialog/dialog_action_button.dart';
import 'package:healthtracker/presentation/widgets/dialog/dialog_title.dart';

class ChangeBloodGlucoseUnitDialog extends StatefulWidget {
  const ChangeBloodGlucoseUnitDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ChangeBloodGlucoseUnitDialogState();
}

class _ChangeBloodGlucoseUnitDialogState extends State<ChangeBloodGlucoseUnitDialog> {
  final _unitService = GetIt.instance<UnitService>();
  late BloodGlucoseUnit? _unit = _unitService.getBloodGlucoseUnit();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogTitle(AppLocalizations.of(context)!.toChangeBloodGlucoseUnit),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<BloodGlucoseUnit>(
            title: Text(BloodGlucoseUnit.kMmolDividedByL.toHumanReadable, style: const TextStyle(fontSize: 18)),
            value: BloodGlucoseUnit.kMmolDividedByL,
            groupValue: _unit,
            onChanged: (BloodGlucoseUnit? value) {
              setState(() {
                _unit = value;
              });
            },
          ),
          RadioListTile<BloodGlucoseUnit>(
            title: Text(BloodGlucoseUnit.kMgDividedByDl.toHumanReadable, style: const TextStyle(fontSize: 18)),
            value: BloodGlucoseUnit.kMgDividedByDl,
            groupValue: _unit,
            onChanged: (BloodGlucoseUnit? value) {
              setState(() {
                _unit = value;
              });
            },
          ),
        ],
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
            Navigator.pop(context, _unit);
          },
        ),
      ],
    );
  }
}
