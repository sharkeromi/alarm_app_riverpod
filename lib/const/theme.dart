import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
         background: cWhiteColor, primary: cPrimaryTintColor, secondary: cTextPrimaryColor));

ThemeData darkMode =
    ThemeData(brightness: Brightness.dark, colorScheme: const ColorScheme.dark(background: cDarkColor, primary: cPrimaryTintColor, secondary: cWhiteColor));
