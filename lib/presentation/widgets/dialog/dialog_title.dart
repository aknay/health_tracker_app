import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  final String text;

  const DialogTitle(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87));
  }
}
