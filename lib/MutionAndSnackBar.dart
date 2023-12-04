// ignore_for_file: file_names

import 'package:flutter/material.dart';

String addPeopleMutation(String newName) => """
mutation MyMutation {
  insert_people(objects: {name: "$newName"}) {
    affected_rows
  }
}
""";

String addTaskMutation(String newtask) => """
mutation MyMutation {
  insert_tasks(objects: {title: "$newtask"}) {
    affected_rows
  }
}


""";

String addAssignmentMutation(String person, String task) => """
mutation MyMutation {
  insert_assignments(objects: {person_name: "$person", task_name: "$task"}) {
    affected_rows
  }
}
""";

String removePeopleMutation(String lastName) => """
mutation MyMutation {
  delete_people(where: {name: {_eq: "$lastName"}}) {
    affected_rows
  }
}

""";

String removeTasksMutation(String lastTask) => """

mutation MyMutation {
  delete_tasks(where: {title: {_eq: "$lastTask"}}) {
    affected_rows
  }
}

""";

String removeAssighmentMutation(String lastPerson, String lastName) => """
mutation MyMutation {
  delete_assignments(where: {person_name: {_eq: "$lastPerson"}, task_name: {_eq: "$lastName"}}) {
    affected_rows
  }
}

""";
SnackBar snackbar(String error) => SnackBar(
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            error,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
    );
