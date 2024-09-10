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

class History {
  String title;
  String description;

  History({
    required this.title,
    required this.description,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      title: json['title'],
      description: json['description'],
    );
  }
}

class Bank {
  String name;
  String code;

  Bank({
    required this.name,
    required this.code,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'],
      code: json['code'],
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

Future<List<Bank>> fetchBanks() async {
  List<Bank> banks = [];
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/v1/bankList/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      banks = List<Bank>.from(json['data'].map((bank) => Bank.fromJson(bank)));
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return banks;
}

Future<String> fetchBankUser(String bankCode, String accountNumber) async {
  String name = '';
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/v1/bankResolve/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "token": token,
        "bank_code": bankCode,
        "account_number": accountNumber,
      },
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      name = json['data']['account_name'];
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return name;
}

Future<bool> withdrawMoney(String amount) async {
  bool withdraw = false;
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/v1/withdraw/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "token": token,
        "amount": amount,
      },
    );
    if (response.statusCode == 200) {
      withdraw = true;
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return withdraw;
}

Future<User> getUserData(String refresh) async {
  User user = defaultUser;
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/v1/getuser/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token, "refresh": refresh},
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
      Uri.parse('http://127.0.0.1:8000/api/v1/tasks/'),
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

Future<List<History>> getUserHistory() async {
  List<History> history = [];
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/v1/history/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      history = List<History>.from(
          data['history'].map((history) => History.fromJson(history)));
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return history;
}

Future<String> submitTasks(int taskId, html.File selectedImage) async {
  String token = html.window.localStorage['token'] ?? '';
  try {
    var uri = Uri.parse('http://127.0.0.1:8000/api/v1/submit/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['token'] = token;
    request.fields['taskId'] = taskId.toString();
    var reader = html.FileReader();
    reader.readAsArrayBuffer(selectedImage);
    await reader.onLoad.first;
    var fileBytes = reader.result as List<int>;
    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      fileBytes,
      filename: selectedImage.name,
    );
    request.files.add(multipartFile);

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);
    return data['message'];
  } catch (e) {
    print('Error: $e');
  }
  return 'Something went wrong';
}

Future<Map<String, dynamic>> getUserLogin(String email, String password) async {
  Map<String, dynamic> json = {};
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/v1/signin/'),
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
