import 'package:flutter/material.dart';

class ElevatedButtonBuilder {
  static ElevatedButton build({
    required String label,
    required VoidCallback onPressed,
    Color? buttonColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor ?? Colors.black,
        onPrimary: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }
}