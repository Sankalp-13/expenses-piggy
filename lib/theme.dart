import 'package:flutter/material.dart';

// Define Theme Colors
const Color pastelBlue = Color(0xFFAAC4FF);
const Color pastelPink = Color(0xFFF3A6A6);
const Color textColor = Colors.black87;

final ThemeData pastelTheme = ThemeData(
  primaryColor: pastelBlue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: pastelBlue,
    titleTextStyle: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: textColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: pastelPink,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: pastelBlue,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: pastelPink,
    foregroundColor: Colors.white,
  ),
);
