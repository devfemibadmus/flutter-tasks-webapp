import 'package:flutter/material.dart';
import 'package:tasks/account.dart';
import 'package:tasks/model.dart';
import 'balance.dart';
import 'tasks.dart';
import 'user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedIndex = 1;
  User user = defaultUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final fetchedUser = await userData();
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user.name == '' && user.email == '') {
      return const MaterialApp(
        home: AccountPage(),
      );
    } else {
      return MaterialApp(
        home: home(),
      );
    }
  }

  Widget home() {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          BalancePage(user: user),
          TasksPage(user: user),
          UserPage(user: user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Balance'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Nigga Mike'),
        ],
        currentIndex: _selectedIndex,
        onTap: ((index) {
          setState(() {
            _selectedIndex = index;
          });
        }),
      ),
    );
  }
}
