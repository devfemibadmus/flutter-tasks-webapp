import 'package:flutter/material.dart';
import 'withdraw_page.dart';
import 'tasks.dart';
import 'account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const WithdrawPage(),
    const TasksPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Colors.teal.shade700,
          unselectedItemColor: Colors.teal,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), label: 'Withdraw'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Account'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
