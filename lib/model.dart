// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class User {
  int balance;
  String name;
  String email;
  bool isVerify;
  Status status;
  List<Task> tasks;

  User({
    required this.name,
    required this.email,
    required this.status,
    required this.tasks,
    required this.balance,
    required this.isVerify,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['user']['name'],
      email: json['user']['email'],
      balance: json['user']['balance'],
      isVerify: json['user']['isVerify'],
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
  tasks: [],
  email: '',
  balance: 0,
  isVerify: false,
  status: Status(pendingTasks: 0, passedTasks: 0, failedTasks: 0),
);

Future<User> getUserData() async {
  User user = defaultUser;
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      user = User.fromJson(json);
      html.window.localStorage['token'] = json['token'] ?? '';
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return user;
}

Future<List<Task>> getUserTasks() async {
  List<Task> tasks = [];
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/tasks/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      tasks = List<Task>.from(data['tasks'].map((task) => Task.fromJson(task)));
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return tasks;
}

Future<Map<String, dynamic>> getUserLogin(String email, String password) async {
  Map<String, dynamic> json = {};
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        'email': email,
        'password': password,
      },
    );
    json = jsonDecode(response.body);
    html.window.localStorage['token'] = json['token'] ?? '';
  } catch (e) {
    print('Error: $e');
  }
  return json;
}
