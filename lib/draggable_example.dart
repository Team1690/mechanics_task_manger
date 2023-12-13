import 'package:flutter/material.dart';

class DraggableExample extends StatefulWidget {
  const DraggableExample({super.key, required this.name});
  final String name;
  @override
  State<DraggableExample> createState() => _DraggableExampleState();
}

class _DraggableExampleState extends State<DraggableExample> {
  String acceptedData = "";

  @override
  Widget build(BuildContext context) {
    // Check if the theme is dark
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set the color based on the theme mode
    Color? backgroundColor = isDarkMode ? Colors.grey[300] : Colors.orange;

    return Draggable<String>(
      data: widget.name,
      feedback: Container(
        height: 70.0,
        width: 70.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          widget.name,
          textAlign: TextAlign.center,
        ),
      ),
      childWhenDragging: const SizedBox(),
      child: Container(
        height: 70.0,
        width: 70.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            widget.name,
          ),
        ),
      ),
    );
  }
}
