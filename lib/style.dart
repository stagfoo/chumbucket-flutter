import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final manabeeTheme = MixThemeData(
  colors: {
    'primary': Colors.blue,
    'secondary': Colors.purple,
    'accent': Colors.amber,
    'background': Colors.black,
    'surface': const Color(0xFF1F1F1F),
    'onSurface': Colors.white,
    'onPrimary': Colors.white,
    'onSecondary': Colors.white,
  },
  textStyles: {
    'heading1': const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    'heading2': const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    'body': const TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  },
  space: {
    'small': 8.0,
    'medium': 16.0,
    'large': 24.0,
  },
);