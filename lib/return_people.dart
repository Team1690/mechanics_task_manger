import 'package:flutter/material.dart';

class ReturnPeople extends StatelessWidget {
  const ReturnPeople({super.key, required this.onPressed, required this.name});
  final String name;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(name),
    );
  }
}
