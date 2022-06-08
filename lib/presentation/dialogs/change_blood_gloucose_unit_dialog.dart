import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../domain/models/enums.dart';
import '../../domain/services/units_service.dart';
import '../widgets/dialog/dialog_action_button.dart';
import '../widgets/dialog/dialog_title.dart';

class ChangeBloodGlucoseUnitDialog extends StatefulWidget {
  const ChangeBloodGlucoseUnitDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeBloodGlucoseDialogState createState() => _ChangeBloodGlucoseDialogState();
}

class _ChangeBloodGlucoseDialogState extends State<ChangeBloodGlucoseUnitDialog> {
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
            title: Text(BloodGlucoseUnit.MMOL_DIVIDED_BY_L.toHumanReadable, style: const TextStyle(fontSize: 18)),
            value: BloodGlucoseUnit.MMOL_DIVIDED_BY_L,
            groupValue: _unit,
            onChanged: (BloodGlucoseUnit? value) {
              setState(() {
                _unit = value;
              });
            },
          ),
          RadioListTile<BloodGlucoseUnit>(
            title: Text(BloodGlucoseUnit.MG_DIVIDED_BY_DL.toHumanReadable, style: const TextStyle(fontSize: 18)),
            value: BloodGlucoseUnit.MG_DIVIDED_BY_DL,
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
            ///TODO

            Navigator.pop(context, _unit);
          },
        ),
      ],
    );
  }
}
