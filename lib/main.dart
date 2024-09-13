import 'package:flutter/material.dart';
import 'package:tasks/account.dart';
import 'package:tasks/model.dart';
import 'balance.dart';
import 'dart:async';
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
        future: getUserData("false"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
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

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  String _loadingText = "Loading";
  int _dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
          _loadingText = "Loading${"." * _dotCount}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'logo.png',
              height: 250,
            ),
            const SizedBox(height: 20),
            Text(
              _loadingText,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _fetchBanks();
  }

  Future<void> _updateUser() async {
    setState(() {
      isLoading = true;
    });
    User user = await getUserData("true");
    setState(() {
      this.user = user;
      isLoading = false;
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
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              BalancePage(
                  key: ValueKey([banks, user]),
                  user: user,
                  banks: banks,
                  onrefresh: _updateUser),
              TasksPage(
                  key: ValueKey(user), user: user, onrefresh: _updateUser),
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
              const BottomNavigationBarItem(
                  icon: Icon(Icons.task), label: 'Tasks'),
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
        ),
        if (isLoading)
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          ),
      ],
    );
  }
}
