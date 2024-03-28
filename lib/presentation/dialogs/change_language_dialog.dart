import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:healthtracker/domain/services/language_service.dart';
import 'package:healthtracker/domain/value_objects/models.dart';
import 'package:healthtracker/main.dart';
import 'package:healthtracker/presentation/widgets/dialog/dialog_action_button.dart';
import 'package:healthtracker/presentation/widgets/dialog/dialog_title.dart';

class ChangeLanguageDialog extends StatefulWidget {
  const ChangeLanguageDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ChangeLanguageDialogState();
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
                value: LanguageOption.kEnglish,
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
                value: LanguageOption.kMyanmar,
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
              if (_cardMethod == LanguageOption.kEnglish) {
                _languageService.set(_cardMethod!).then((value) => {MyApp.setLocale(context, const Locale('en', ''))});
              } else if (_cardMethod == LanguageOption.kMyanmar) {
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