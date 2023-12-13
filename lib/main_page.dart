import 'package:flutter/material.dart';
import 'data_base.dart';
import 'return_people.dart';
import "tasks.dart";
import 'draggable_example.dart';
import 'MutionAndSnackBar.dart';
import 'theme_manager.dart';

class MainPage extends StatelessWidget {
  MainPage({
    super.key,
    required this.switchMode,
    required this.assignments,
    required this.tasks,
    required this.names,
    required this.onSwitchPressed,
    required this.onPressedRemove,
    required this.onPressedadd,
    required this.onTaskAssignmentDataRecieved,
  });

  final List<String> names;
  final List<String> tasks;
  final Map<String, int> assignments;
  final bool switchMode;
  final void Function() onSwitchPressed;
  final void Function(String name) onPressedRemove;
  final void Function(String name) onPressedadd;
  final void Function(String task, String assignedPerson)
      onTaskAssignmentDataRecieved;
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MyBackgroundWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...tasks.map((task) => Task(
                            task: task,
                            onAccept: (final String assignedPerson) {
                              sentToDB(
                                  addAssignmentMutation(assignedPerson, task),
                                  (error) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar(error));
                              }, () {
                                onTaskAssignmentDataRecieved(
                                    task, assignedPerson);
                              });
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(children: [
                                ...assignments.keys
                                    .where((name) =>
                                        assignments[name] ==
                                        tasks.indexOf(task))
                                    .map((person) {
                                  return ReturnPeople(
                                    name: person,
                                    onPressed: () {
                                      sentToDB(
                                          removeAssighmentMutation(
                                              person, task), (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar(error));
                                      }, () {});
                                    },
                                  );
                                })
                              ]),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              ...List.generate(
                names.length,
                (index) => Expanded(
                  child: DraggableExample(
                    name: names[index],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.all(16.0)),
              Expanded(
                child: TextField(
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.black),
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                        borderSide: BorderSide(),
                      ),
                      hintText: "הכנס חבר צוות / משימה",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintTextDirection: TextDirection.rtl),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.black,
                onPressed: () {
                  onPressedadd(nameController.text);
                },
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                color: Colors.black,
                onPressed: () {
                  onPressedRemove(nameController.text);
                },
              ),
              IconButton(
                color: !switchMode ? Colors.red : Colors.green,
                icon: !switchMode
                    ? const Icon(Icons.account_circle_rounded)
                    : const Icon(Icons.add_to_photos),
                onPressed: onSwitchPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
