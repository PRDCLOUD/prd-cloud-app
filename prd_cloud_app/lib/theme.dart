import 'package:flutter/material.dart';

class AppThemeColors {
  static Color get primary => const Color(0xff209e91);
}

class AppTheme {
  static RoundedRectangleBorder get cardShape => 
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5), // if you need this
      side: BorderSide(
        color: Colors.grey.withOpacity(0.3),
        width: 1,
      ),
    );
}