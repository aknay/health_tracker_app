import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/presentation/dialogs/change_language_dialog.dart';
import 'package:healthtracker/presentation/settings/units_page/units_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ///disable for now
        // IntrinsicHeight(
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 16),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Center(
        //           child: Padding(
        //             padding: EdgeInsets.only(left: 16),
        //             child: Icon(Icons.group_outlined, size: 30.0),
        //           ),
        //         ),
        //         Flexible(
        //           child: ListTile(
        //             title: const Text(
        //               "Acknowledgement",
        //               style: TextStyle(
        //                 fontSize: 16.0,
        //               ),
        //             ),
        //             subtitle: const Text(
        //               "Grateful to the people who make it available for everyone to use.",
        //             ),
        //             onTap: () {},
        //           ),
        //         ),
        //         const Center(
        //           child: Padding(
        //             padding: EdgeInsets.only(right: 24),
        //             child: Icon(Icons.arrow_forward_ios_outlined, size: 14.0),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 0),
                  child: Icon(Icons.language, size: 30.0),
                ),
              ),
              Flexible(
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.changeLanguage,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const ChangeLanguageDialog();
                        });
                  },
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 0),
                    child: Icon(Icons.straighten, size: 30.0),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.units,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UnitPage()));
                    },
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 24),
                    child: Icon(Icons.arrow_forward_ios_outlined, size: 14.0),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
