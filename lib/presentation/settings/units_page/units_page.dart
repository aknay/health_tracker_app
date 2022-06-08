import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/domain/models/enums.dart';
import 'package:healthtracker/presentation/dialogs/change_blood_gloucose_unit_dialog.dart';
import 'package:healthtracker/presentation/settings/units_page/units_page_view_model.dart';

class UnitPage extends StatefulWidget {
  const UnitPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  final UnitsPageViewModel _viewModel = UnitsPageViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///not to show keyboard after a widget is pressed
    FocusManager.instance.primaryFocus?.unfocus();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.units, style: const TextStyle(fontSize: 18)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(AppLocalizations.of(context)!.bloodGlucoseUnit, style: const TextStyle(fontSize: 18)),
                  const Spacer(),
                  StreamBuilder<String>(
                      stream: _viewModel.bloodGlucoseUnitStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError || snapshot.data == null) {
                          return const Text("Has error");
                        }
                        return Text(snapshot.data!, style: const TextStyle(fontSize: 18));
                      })
                ],
              ),
              onTap: () async {
                BloodGlucoseUnit? v = await showDialog(
                    context: context,
                    builder: (context) {
                      return const ChangeBloodGlucoseUnitDialog();
                    });

                await _viewModel.setUnit(v);
              },
            )
          ],
        ),
      ),
    );
  }
}
