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

  static final List<Widget> _pages = <Widget>[
    const BalancePage(),
    const TasksPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<User>(
        future: userData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            setState(() {
              user = snapshot.data!;
            });
            return home();
          } else {
            return const AccountPage();
          }
        },
      ),
    );
  }

  Widget home() {
    return Scaffold(
      body: _pages[_selectedIndex],
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
