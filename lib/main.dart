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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<User>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.email != '') {
            User user = snapshot.data!;
            return HomePage(user: user);
          } else {
            return const AccountPage();
          }
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  late User user;
  late List<Bank> banks = [];

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _fetchBanks();
  }

  Future<void> _updateUser() async {
    User user = await getUserData();
    setState(() {
      this.user = user;
    });
  }

  Future<void> _fetchBanks() async {
    List<Bank> fetchedBanks = await fetchBanks();
    setState(() {
      banks = fetchedBanks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          BalancePage(
              key: ValueKey(banks),
              user: user,
              banks: banks,
              onrefresh: _updateUser),
          TasksPage(key: ValueKey(user), user: user, onrefresh: _updateUser),
          UserPage(key: ValueKey(user), user: user, onrefresh: _updateUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Balance'),
          const BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle), label: user.name),
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
