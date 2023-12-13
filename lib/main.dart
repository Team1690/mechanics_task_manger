import 'package:flutter/material.dart';
import 'theme_manager.dart'; // Import the template.dart file
import 'scaffhold.dart';

void main() {
  runApp(
    const ThemeManager(
      child: SafeArea(
        child: MyScaffold(),
      ),
    ),
  );
}
