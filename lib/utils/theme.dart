import 'package:flutter/material.dart';

ThemeData qtloggerTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: Colors.cyan[300],
    primaryColor: Colors.black,
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.white,
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: 'Muli',
          fontWeight: FontWeight.w300,
          color: Colors.black,
          fontSize: 30,
        ),
      ),
      elevation: 1, 
    ),
    textTheme: base.textTheme.copyWith(
      body1: TextStyle(
        fontFamily: 'Abel',
        fontSize: 20,
        color: Colors.black,
      ),
      subtitle: TextStyle(
        fontFamily: 'San Serif',
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      
    ),
  );
}
