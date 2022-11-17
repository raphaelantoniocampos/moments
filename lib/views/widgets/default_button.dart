import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double minWidth;
  final double height;
  final double fontSize;

  const DefaultButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.textColor,
      required this.backgroundColor,
      required this.minWidth,
      required this.height,
      required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: backgroundColor,
      borderRadius: BorderRadius.circular(15),
      child: MaterialButton(
        minWidth: minWidth,
        height: height,
        onPressed: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
