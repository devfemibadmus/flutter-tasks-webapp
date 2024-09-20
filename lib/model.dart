// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class User {
  int balance;
  String name;
  String email;
  bool isVerify;
  bool hasPaid;
  double rearns;
  int minWithdraw;
  int passedTasks;
  int failedTasks;
  int pendingTasks;
  String? referral;
  List<Task> tasks;
  bool documentSubmitted;

  User({
    required this.name,
    required this.email,
    required this.tasks,
    required this.balance,
    required this.referral,
    required this.hasPaid,
    required this.rearns,
    required this.minWithdraw,
    required this.isVerify,
    required this.passedTasks,
    required this.failedTasks,
    required this.pendingTasks,
    required this.documentSubmitted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['user']['name'],
      email: json['user']['email'],
      balance: json['user']['balance'],
      isVerify: json['user']['isVerify'],
      rearns: json['user']['rearns'],
      hasPaid: json['user']['hasPaid'],
      referral: json['user']['referral'],
      passedTasks: json['user']['passedTasks'],
      failedTasks: json['user']['failedTasks'],
      pendingTasks: json['user']['pendingTasks'],
      minWithdraw: json['user']['minWithdraw'],
      documentSubmitted: json['user']['documentSubmitted'],
      tasks: List<Task>.from(json['tasks'].map((task) => Task.fromJson(task))),
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

class PayOut {
  String dates;
  String action;
  String amount;
  String description;

  PayOut({
    required this.dates,
    required this.action,
    required this.amount,
    required this.description,
  });

  factory PayOut.fromJson(Map<String, dynamic> json) {
    return PayOut(
      dates: json['dates'],
      action: json['action'],
      amount: json['amount'],
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
      code: json['code'].toString(),
    );
  }
}

User defaultUser = User(
  name: '',
  tasks: [],
  email: '',
  balance: 0,
  isVerify: false,
  referral: '',
  hasPaid: false,
  documentSubmitted: false,
  passedTasks: 0,
  failedTasks: 0,
  pendingTasks: 0,
  rearns: 0,
  minWithdraw: 0,
);

Future<List<Bank>> fetchBanks() async {
  List<Bank> banks = [];
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/bankList/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      banks = List<Bank>.from(json['data'].map((bank) => Bank.fromJson(bank)));
    } else {
      // print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }
  return banks;
}

Future<String> fetchPayment() async {
  String payment = '';
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/payment/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      payment = json['paymentUrl'];
    } else {
      // print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }
  return payment;
}

Future<String> fetchBankUser(String bankCode, String accountNumber) async {
  String name = '';
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/bankResolve/'),
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
      // print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }
  return name;
}

Future<bool> withdrawMoney(String amount) async {
  bool withdraw = false;
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/withdraw/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "token": token,
        "amount": amount,
      },
    );
    if (response.statusCode == 200) {
      withdraw = true;
    } else {
      // print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }
  return withdraw;
}

Future<User> getUserData(bool refresh) async {
  User user = defaultUser;
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/getuser/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token, "refresh": refresh.toString()},
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      user = User.fromJson(json);
      html.window.localStorage['token'] = json['token'] ?? '';
    } else {
      // print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }
  return user;
}

Future<List<Task>> getUserTasks() async {
  List<Task> tasks = [];
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/tasks/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      tasks = List<Task>.from(data['tasks'].map((task) => Task.fromJson(task)));
    } else {
      // print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }
  return tasks;
}

Future<List<PayOut>> getUserPayOut() async {
  List<PayOut> payouts = [];
  String token = html.window.localStorage['token'] ?? '';
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/payouts/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"token": token},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      payouts = List<PayOut>.from(
          data['payouts'].map((payouts) => PayOut.fromJson(payouts)));
    } else {
      // print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }
  return payouts;
}

Future<String> submitTasks(int taskId, html.File selectedImage) async {
  String token = html.window.localStorage['token'] ?? '';
  try {
    var uri = Uri.parse('$baseUrl/api/v1/submit/');
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
    // print('Error: $e');
  }
  return 'Something went wrong';
}

Future<String> verifyAccountDocs(
    html.File studentIdFile, html.File govIdFile) async {
  String token = html.window.localStorage['token'] ?? '';
  try {
    var uri = Uri.parse('$baseUrl/api/v1/verification/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['token'] = token;

    var govIdReader = html.FileReader();
    govIdReader.readAsArrayBuffer(govIdFile);
    await govIdReader.onLoad.first;
    var govIdFileBytes = govIdReader.result as List<int>;
    var govIdMultipartFile = http.MultipartFile.fromBytes(
      'govId',
      govIdFileBytes,
      filename: govIdFile.name,
    );
    request.files.add(govIdMultipartFile);

    var studentIdReader = html.FileReader();
    studentIdReader.readAsArrayBuffer(studentIdFile);
    await studentIdReader.onLoad.first;
    var studentIdFileBytes = studentIdReader.result as List<int>;
    var studentIdMultipartFile = http.MultipartFile.fromBytes(
      'studentId',
      studentIdFileBytes,
      filename: studentIdFile.name,
    );
    request.files.add(studentIdMultipartFile);

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);
    return data['message'];
  } catch (e) {
    // print('Error: $e');
  }
  return 'Something went wrong';
}

Future<Map<String, dynamic>> getUserSignin(
    String email, String password) async {
  Map<String, dynamic> json = {};
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/signin/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        'email': email,
        'password': password,
      },
    );
    json = jsonDecode(response.body);
    html.window.localStorage['token'] = json['token'] ?? '';
  } catch (e) {
    // print('Error: $e');
  }
  return json;
}

Future<Map<String, dynamic>> getUserSignup(
    String fullName, String email, String referral, String password) async {
  Map<String, dynamic> json = {};
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/signup/'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        'email': email,
        'fullName': fullName,
        'referral': referral,
        'password': password,
      },
    );
    json = jsonDecode(response.body);
    html.window.localStorage['token'] = json['token'] ?? '';
  } catch (e) {
    // print('Error: $e');
  }
  return json;
}

String baseUrl = 'http://127.0.0.1:8000';
