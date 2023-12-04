import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

Stream<List<TaskAssignment>> fetchAssignments() {
  final GraphQLClient client = getClient();
  const String subscription = """
subscription MySubscription {
  assignments(where: {}) {
    
      person_name
      task_name
    
  }
}

""";
  final Stream<QueryResult<List<TaskAssignment>>> result =
      client.subscribe(SubscriptionOptions(
    document: gql(subscription),
    parserFn: (final Map<String, dynamic> data) {
      List<dynamic> assignments = data["assignments"] as List<dynamic>;
      return assignments.map((e) {
        final String person = e["person_name"] as String;
        final String task = e["task_name"] as String;
        return TaskAssignment(person: person, taskName: task);
      }).toList();
    },
  ));
  return result.map((final QueryResult<List<TaskAssignment>> event) =>
      event.mapQueryResult());
}

class TaskAssignment {
  TaskAssignment({
    required this.person,
    required this.taskName,
  });
  final String person;
  final String taskName;
}

GraphQLClient getClient() {
  // final HttpLink httpLink = HttpLink(
  //     "https://natural-rhino-54.hasura.app/v1/graphql",
  //     defaultHeaders: {
  //       "x-hasura-admin-secret":
  //           "0F4ePrX2sBhjLMUwhnq0gGn2Rk2TBex4croiIeVk3HvTs1p3Wvac2ssaYYcEnqHS"
  //     });
  final WebSocketLink webSocketLink = WebSocketLink(
    "wss://natural-rhino-54.hasura.app/v1/graphql",
    config: const SocketClientConfig(initialPayload: {
      "headers": {
        "x-hasura-admin-secret":
            "0F4ePrX2sBhjLMUwhnq0gGn2Rk2TBex4croiIeVk3HvTs1p3Wvac2ssaYYcEnqHS"
      }
    }),
  );
  return GraphQLClient(
    link: webSocketLink,
    cache: GraphQLCache(),
  );
}

Stream<List<String>> fetchpeople() {
  final GraphQLClient client = getClient();
  const String subscription = """

  subscription MySubscription {
 	people {
    name
  }
}

""";
  final Stream<QueryResult<List<String>>> result =
      client.subscribe(SubscriptionOptions(
    document: gql(subscription),
    parserFn: (final Map<String, dynamic> data) {
      List<dynamic> people = data["people"] as List<dynamic>;
      return people.map((e) {
        final String people = e["name"] as String;
        return people;
      }).toList();
    },
  ));
  return result
      .map((final QueryResult<List<String>> event) => event.mapQueryResult());
}

extension MapQueryResult<A> on QueryResult<A> {
  A mapQueryResult() => (hasException
      ? throw exception!
      : data == null
          ? (throw Exception("Data returned null"))
          : parsedData!);
}

extension MapSnapshot<T> on AsyncSnapshot<T> {
  V mapSnapshot<V>({
    required final V Function(T) onSuccess,
    required final V Function() onWaiting,
    required final V Function() onNoData,
    required final V Function(Object) onError,
  }) =>
      hasError
          ? onError(error!)
          : (ConnectionState.waiting == connectionState
              ? onWaiting()
              : (hasData ? onSuccess(data as T) : onNoData()));
}

void sentToDB(String mutation, void Function(String error) onFail,
    void Function() onSuccess) async {
  String errorMessage = "";
  final GraphQLClient client = getClient();
  final QueryResult<void> queryResult = await client.mutate(
    MutationOptions<void>(
      document: gql(mutation),
    ),
  );
  final OperationException? exception = queryResult.exception;

  if (exception != null) {
    final List<GraphQLError> errors = exception.graphqlErrors;
    if (errors.length == 1) {
      final GraphQLError error = errors.single;
      errorMessage =
          error.extensions?["code"]?.toString() == "constraint-violation"
              ? "This person/task already exists"
              : error.message;
    } else {
      errorMessage = errors.join(", ");
    }
    onFail(errorMessage);
  } else {}
}

Stream<List<String>> fetchTaskName() {
  final GraphQLClient client = getClient();
  const String subscription = """

subscription MySubscription {
  tasks {
    title
  }
}

""";

  final Stream<QueryResult<List<String>>> result =
      client.subscribe(SubscriptionOptions(
    document: gql(subscription),
    parserFn: (final Map<String, dynamic> data) {
      List<dynamic> tasks = data["tasks"] as List<dynamic>;
      return tasks.map((e) {
        final String tasks = e["title"] as String;
        return tasks;
      }).toList();
    },
  ));
  return result
      .map((final QueryResult<List<String>> event) => event.mapQueryResult());
}
