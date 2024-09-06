import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  WithdrawPageState createState() => WithdrawPageState();
}

class WithdrawPageState extends State<WithdrawPage> {
  String _selectedBank = 'Select Bank';
  String _accountName = '';
  String _accountNumber = '';
  String _amount = '';

  // Placeholder for fetching account name based on account number
  void fetchAccountName() {
    setState(() {
      _accountName = 'John Doe'; // Mock response
    });
  }

  // Placeholder for withdrawing
  void processWithdraw() {
    // Implement withdraw processing here
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Withdraw Failed"),
              content: const Text("Try again later."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Withdraw")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedBank,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBank = newValue!;
                });
              },
              items: <String>['Select Bank', 'Bank A', 'Bank B']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Account Number"),
              onChanged: (value) {
                _accountNumber = value;
                fetchAccountName(); // Trigger fetching
              },
            ),
            const SizedBox(height: 20),
            Text("Account Name: $_accountName",
                style: const TextStyle(fontSize: 16)),
            TextField(
              decoration: const InputDecoration(labelText: "Amount"),
              onChanged: (value) {
                _amount = value;
              },
            ),
            ElevatedButton(
              onPressed: processWithdraw,
              child: const Text("Withdraw"),
            ),
          ],
        ),
      ),
    );
  }
}
