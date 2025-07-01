import 'package:flutter/material.dart';

import '../constants/constants.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final Color? color;
  final double fontSize;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final int? maxLines;
  const TextWidget({
    super.key,
    required this.text,
    this.color,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 13,
    this.decoration,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: false,
      textAlign: textAlign,
      maxLines: maxLines ?? 2,
      style: TextStyle(
        fontFamily: 'Open Sans Hebrew',
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: appThemeColour,
        fontSize: fontSize,
        overflow: TextOverflow.ellipsis,
        height: 0,
      ),
    );
  }
}
