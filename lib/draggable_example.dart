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
    return Draggable<String>(
      data: widget.name,
      feedback: Container(
        height: 70.0,
        width: 70.0,
        decoration: const BoxDecoration(
          color: Colors.orange,
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
        decoration: const BoxDecoration(
          color: Colors.orange,
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
