import 'package:flutter/material.dart';

class ThemeManager extends StatefulWidget {
  final Widget child;

  const ThemeManager({Key? key, required this.child}) : super(key: key);

  @override
  _ThemeManagerState createState() => _ThemeManagerState();

  static _ThemeManagerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeManagerState>();
  }
}

class _ThemeManagerState extends State<ThemeManager> {
  ThemeData _themeData;

  _ThemeManagerState()
      : _themeData = _lightTheme; // Start with light theme by default

  static final ThemeData _lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      color: Colors.orange[100],
    ),
  );

  static final ThemeData _darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey[850],
    primaryColorDark: Colors.black,
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
    ),
  );

  void toggleTheme() {
    setState(() {
      _themeData = _themeData == _lightTheme ? _darkTheme : _lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      home: widget.child,
    );
  }
}

class MyBackgroundWidget extends StatelessWidget {
  final Widget child;

  const MyBackgroundWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    // Check if the theme is dark
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set the background color based on the theme mode
    // Providing a default color if the chosen color is null
    Color? backgroundColor = isDarkMode
        ? (Colors.grey[850] ?? Colors.grey) // Fallback to Colors.grey if null
        : Colors.orange[100];

    return Container(
      color: backgroundColor,
      child: child,
    );
  }
}
