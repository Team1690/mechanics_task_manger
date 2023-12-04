import 'package:flutter/material.dart';
import 'scaffhold.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My app',
      home: SafeArea(
        child: MyScaffold(),
      ),
    ),
  );
}
