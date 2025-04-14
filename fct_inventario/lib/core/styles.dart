import 'package:flutter/material.dart';

class AppStyles {
  static EdgeInsetsGeometry defaultPadding = EdgeInsets.all(16.0);
  static EdgeInsetsGeometry defaultMargin = EdgeInsets.symmetric(horizontal: 20.0);

  static TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static InputDecoration textFieldDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black),
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(),
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        fillColor: Colors.grey[200],
        filled: true,
      ),
      textTheme: TextTheme(
        // Reemplaza headline1 con un estilo válido en la versión actual
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 16),
      ),
    );
  }
}
