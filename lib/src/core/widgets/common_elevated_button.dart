import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color? shadowColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final TextStyle style;
  final double width;
  final double height;
  final VoidCallback onPressed;
  BoxDecoration? decoration;

  CommonElevatedButton({
    super.key,
    required this.text,
    this.buttonColor = Colors.black,
    this.shadowColor,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.elevation = 4.0,
    required this.style,
    this.width = 150.0,
    this.height = 50.0,
    this.decoration,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: buttonColor,
          elevation: elevation,
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: style,
          textScaler: const TextScaler.linear(1.0),
        ),
      ),
    );
  }
}
