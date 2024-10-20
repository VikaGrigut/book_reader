import 'package:flutter/material.dart';

const Color primaryColor = Colors.white;

final darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
        color: Colors.grey[850],
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 23)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
            textStyle: TextStyle(color: Colors.black),
            backgroundColor: Colors.grey,
            minimumSize: Size(85, 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
    scaffoldBackgroundColor: Colors.black,
    dialogTheme: DialogTheme(backgroundColor: Colors.grey[850]),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey, foregroundColor: Colors.white),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: Colors.white)),
    dividerTheme: DividerThemeData(color: Colors.grey[800]),
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor, brightness: Brightness.dark));

final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
        color: Colors.white70,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 23)),
    scaffoldBackgroundColor: Colors.white,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
            textStyle: TextStyle(color: Colors.black),
            backgroundColor: Colors.grey,
            minimumSize: Size(85, 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey, foregroundColor: Colors.black),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: Colors.black)),
    dividerTheme: DividerThemeData(color: Colors.grey),
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor, brightness: Brightness.light));
