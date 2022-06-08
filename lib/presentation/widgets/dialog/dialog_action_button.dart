import 'package:flutter/widgets.dart';

import '../../constant.dart';

class DialogActionButton extends StatelessWidget {
  final String text;
  const DialogActionButton(
      this.text,{
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style:
    const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 18));
  }
}