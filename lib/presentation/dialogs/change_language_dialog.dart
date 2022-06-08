import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../domain/services/language_service.dart';
import '../../domain/value_objects/models.dart';
import '../../main.dart';
import '../widgets/dialog/dialog_action_button.dart';
import '../widgets/dialog/dialog_title.dart';

class ChangeLanguageDialog extends StatefulWidget {
  const ChangeLanguageDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeLanguageDialogState createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  final _languageService = GetIt.instance<LanguageService>();
  late LanguageOption? _cardMethod = _languageService.get();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogTitle(AppLocalizations.of(context)!.changeLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Radio<LanguageOption>(
                value: LanguageOption.ENGLISH,
                groupValue: _cardMethod,
                onChanged: (LanguageOption? value) {
                  setState(() {
                    _cardMethod = value;
                  });
                },
              ),
              const Text("English", style: TextStyle(fontSize: 18)),
            ],
          ),
          Row(
            children: [
              Radio<LanguageOption>(
                value: LanguageOption.MYANMAR,
                groupValue: _cardMethod,
                onChanged: (LanguageOption? value) {
                  setState(() {
                    _cardMethod = value;
                  });
                },
              ),
              const Text("မြန်မာ", style: TextStyle(fontSize: 18)),
            ],
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
            if (_cardMethod != null) {
              if (_cardMethod == LanguageOption.ENGLISH) {
                _languageService.set(_cardMethod!).then((value) => {MyApp.setLocale(context, const Locale('en', ''))});
              } else if (_cardMethod == LanguageOption.MYANMAR) {
                _languageService.set(_cardMethod!).then((value) => {MyApp.setLocale(context, const Locale('my', ''))});
              } else {
                debugPrint("should not reach here");
              }
            }

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
