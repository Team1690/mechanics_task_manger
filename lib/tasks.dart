import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  final String task;
  const Task({
    super.key,
    required this.task,
    required this.onAccept,
    required this.child,
  });
  final Function(String) onAccept;
  final Widget child;
  @override
  State<Task> createState() => _TaskState();
}
// Text() : Text Function(String)
// map(f): f: Text Function(String)

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (
        BuildContext context,
        final _,
        final __,
      ) {
        return FittedBox(
          fit: BoxFit.contain,
          child: Container(
            constraints: const BoxConstraints(minHeight: 100),
            width: 100.0,
            color: Colors.cyan,
            child: Column(
              children: [
                Text(
                  widget.task,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                widget.child
              ],
            ),
          ),
        );
      },
      onAccept: (String data) {
        setState(() {
          widget.onAccept(data);
        });
      },
    );
  }
}
