import 'package:flutter/material.dart';

InputDecoration textInputField(
  String hintText, {

  IconData? prefixIcon,
  IconData? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      color: Color(0xFFB0B0B0),
    ),

    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, color: Color(0xFFB0B0B0))
        : null,

    suffixIcon: suffixIcon != null
        ? Icon(suffixIcon, color: Color(0xFFB0B0B0))
        : null,

    // Border Style
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

    // Enabled Border Style
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFB0B0B0), width: 1),
      borderRadius: BorderRadius.circular(10),
    ),

    // Focused Border Style
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0C8CE9), width: 1.7),
      borderRadius: BorderRadius.circular(10),
    ),

    // Error Border Style
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDC3545), width: 1),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
