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
    if (_selectedBank == 'Select Bank' ||
        _accountNumber.isEmpty ||
        _amount.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Input"),
          content:
              const Text("Please fill in all the fields before withdrawing."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
      return;
    }

    // Mock processing withdraw
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw Funds"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Withdraw Funds",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Bank selection dropdown
            DropdownButtonFormField<String>(
              value: _selectedBank,
              decoration: const InputDecoration(
                labelText: "Select Bank",
                border: OutlineInputBorder(),
              ),
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
            const SizedBox(height: 20),
            // Account number input
            TextField(
              decoration: const InputDecoration(
                labelText: "Account Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _accountNumber = value;
                fetchAccountName(); // Trigger fetching account name
              },
            ),
            const SizedBox(height: 20),
            // Account name display
            Text(
              "Account Name: $_accountName",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Amount input
            TextField(
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _amount = value;
              },
            ),
            const SizedBox(height: 40),
            // Withdraw button
            ElevatedButton.icon(
              onPressed: processWithdraw,
              icon: const Icon(Icons.send),
              label: const Text("Submit Withdraw Request"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
