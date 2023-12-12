import 'package:flutter/material.dart';
import 'package:mechanics_task_manager/data_base.dart';
import 'package:mechanics_task_manager/main_page.dart';
import 'MutionAndSnackBar.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.blue[500]),
      child: Row(
        children: [
          const IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null,
          ),
          Expanded(
            child: title,
          ),
          const IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({super.key});
  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  Color backgroundcolor = Colors.white;
  List<String> names = [];
  List<String> tasks = [];
  Map<String, int> assignments = {};
  Stream<List<String>> tasksname = fetchTaskName();
  Stream<List<TaskAssignment>> assignmentsStream = fetchAssignments();
  Stream<List<String>> peoplename = fetchpeople();
  TextEditingController nameController = TextEditingController();
  bool switchMode = false;

  void initData(List<TaskAssignment> assignments, List<String> peopleNames,
      List<String> taskNames) {
    tasks = taskNames;
    this.assignments = Map.fromEntries(assignments.map(
      (TaskAssignment e) => MapEntry(
        e.person,
        tasks.indexOf(e.taskName),
      ),
    ));
    names = peopleNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
      ),
      body: StreamBuilder(
          stream: tasksname,
          builder: (context, snapshot) => snapshot.mapSnapshot(
              onWaiting: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
              onError: (final Object error) => Text(error.toString()),
              onNoData: () => const Center(
                    child: Text("No data"),
                  ),
              onSuccess: (tasksData) {
                return StreamBuilder(
                  stream: peoplename,
                  builder: (context, snapshot) => snapshot.mapSnapshot(
                      onWaiting: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      onError: (final Object error) => Text(error.toString()),
                      onNoData: () => const Center(
                            child: Text("No data"),
                          ),
                      onSuccess: (namesData) {
                        return StreamBuilder<List<TaskAssignment>>(
                          builder: (
                            final BuildContext context,
                            final AsyncSnapshot<List<TaskAssignment>> snapshot,
                          ) =>
                              snapshot.mapSnapshot(
                                  onWaiting: () => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  onError: (final Object error) =>
                                      Text(error.toString()),
                                  onNoData: () => const Center(
                                        child: Text("No data"),
                                      ),
                                  onSuccess: (assignmentsData) {
                                    initData(
                                        assignmentsData, namesData, tasksData);
                                    return MainPage(
                                      onTaskAssignmentDataRecieved: (
                                        final String task,
                                        final String assignedPerson,
                                      ) =>
                                          setState(() {
                                        assignments.addEntries([
                                          MapEntry(assignedPerson,
                                              tasks.indexOf(task))
                                        ]);
                                      }),
                                      switchMode: switchMode,
                                      assignments: assignments,
                                      names: names,
                                      tasks: tasks,
                                      onPressedadd: (name) {
                                        setState(() {
                                          if (!switchMode) {
                                            sentToDB(
                                              addPeopleMutation(name),
                                              (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        snackbar(error));
                                              },
                                              () {
                                                names.add(name);
                                              },
                                            );
                                          } else {
                                            sentToDB(
                                              addTaskMutation(name),
                                              (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        snackbar(error));
                                              },
                                              () {
                                                tasks.add(name);
                                              },
                                            );
                                          }
                                        });
                                      },
                                      onPressedRemove: (name) {
                                        setState(() {
                                          if (!switchMode) {
                                            sentToDB(removePeopleMutation(name),
                                                (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      snackbar(error));
                                            }, () {
                                              names.remove(name);
                                            });
                                          } else {
                                            sentToDB(removeTasksMutation(name),
                                                (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      snackbar(error));
                                            }, () {
                                              tasks.remove(name);
                                            });
                                          }
                                        });
                                      },
                                      onSwitchPressed: () {
                                        setState(() {
                                          switchMode = !switchMode;
                                        });
                                      },
                                    );
                                  }),
                          stream: assignmentsStream,
                        );
                      }),
                );
              })),
      backgroundColor: backgroundcolor,
    );
  }
}
