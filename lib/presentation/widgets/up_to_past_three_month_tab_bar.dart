import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpToPastThreeMonthTabBar extends StatelessWidget {
  const UpToPastThreeMonthTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.indigo,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(13), // Creates border
          color: Colors.blue),
      tabs: [
        Tab(
            child: Text(
          AppLocalizations.of(context)!.past7Days,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, height: 1.5),
        )),
        Tab(
          child: Text(AppLocalizations.of(context)!.oneMonth,
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.5)),
        ),
        Tab(
          child: Text(AppLocalizations.of(context)!.threeMonthsTabText,
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.5)),
        ),
      ],
    );
  }
}
