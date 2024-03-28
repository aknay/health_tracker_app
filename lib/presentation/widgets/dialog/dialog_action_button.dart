import 'package:flutter/widgets.dart';
import 'package:healthtracker/presentation/constant.dart';


class DialogActionButton extends StatelessWidget {
  final String text;
  const DialogActionButton(
      this.text,{
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Text(text, style:
    const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 18));
  }
}