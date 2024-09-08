import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  String name;
  String email;
  Status status;
  String balance;
  List<Task> tasks;

  User({
    required this.name,
    required this.email,
    required this.status,
    required this.tasks,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      balance: json['balance'],
      status: Status.fromJson(json['status']),
      tasks: List<Task>.from(json['tasks'].map((task) => Task.fromJson(task))),
    );
  }
}

class Status {
  int pendingTasks;
  int passedTasks;
  int failedTasks;

  Status({
    required this.pendingTasks,
    required this.passedTasks,
    required this.failedTasks,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      pendingTasks: json['pendingTasks'],
      passedTasks: json['passedTasks'],
      failedTasks: json['failedTasks'],
    );
  }
}

class Task {
  int id;
  String title;
  double amount;
  String description;

  Task({
    required this.id,
    required this.title,
    required this.amount,
    required this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      description: json['description'],
    );
  }
}

User defaultUser = User(
  name: '',
  email: '',
  balance: '',
  tasks: [],
  status: Status(pendingTasks: 0, passedTasks: 0, failedTasks: 0),
);

Future<User> userData() async {
  User user = defaultUser;
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/getuser/'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      user = User.fromJson(data);
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return user;
}

Future<List<Task>> userTasks() async {
  List<Task> tasks = [];
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/getuser/'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      tasks = List<Task>.from(data['tasks'].map((task) => Task.fromJson(task)));
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return tasks;
}
