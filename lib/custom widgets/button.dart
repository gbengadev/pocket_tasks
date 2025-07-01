import 'package:flutter/material.dart';

import 'text.dart';

class CustomFilledButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final BorderSide? borderSide;
  final double? buttonFontSize;
  const CustomFilledButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.borderSide,
      this.buttonFontSize});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: borderSide ?? BorderSide.none,
          ),
          minimumSize: const Size.fromHeight(50),
        ),
        child: TextWidget(
          text: text,
          color: Colors.white,
          fontSize: buttonFontSize ?? 14,
        ));
  }
}
