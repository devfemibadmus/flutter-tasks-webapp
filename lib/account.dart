import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool isSignUp = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String errorMessage = '';
  String successMessage = '';

  void toggleView() {
    setState(() {
      isSignUp = !isSignUp;
      errorMessage = '';
      successMessage = '';
    });
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }

  void handleSignUp() {
    setState(() {
      // Reset messages
      errorMessage = '';
      successMessage = '';

      // Validation
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        errorMessage = 'All fields are required for Sign Up.';
      } else {
        // Assume success if validated. Here, you'd typically send the data to a server.
        successMessage = 'Sign Up successful! Please sign in.';
        clearFields();
        toggleView(); // Switch to sign in after sign up
      }
    });
  }

  void handleSignIn() {
    setState(() {
      // Reset messages
      errorMessage = '';
      successMessage = '';

      // Validation
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage = 'Email and password are required for Sign In.';
      } else {
        // Fake validation for demo purposes
        // Normally, you'd validate against a database or API response
        if (emailController.text == "test@example.com" &&
            passwordController.text == "password") {
          successMessage = 'Login successful!';
          errorMessage = '';
        } else {
          errorMessage = 'Invalid email or password.';
        }
      }
    });
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Sign Up' : 'Sign In'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display error message
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (successMessage.isNotEmpty)
              Text(
                successMessage,
                style: const TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 20),

            // Show additional fields for Sign Up
            if (isSignUp) ...[
              _buildInputField(
                controller: firstNameController,
                label: 'First Name',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: lastNameController,
                label: 'Last Name',
              ),
              const SizedBox(height: 20),
            ],
            _buildInputField(
              controller: emailController,
              label: 'Email',
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isSignUp) {
                  handleSignUp();
                } else {
                  handleSignIn();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.all(16.0),
              ),
              child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: toggleView,
              child: Text(
                isSignUp
                    ? 'Already have an account? Sign In'
                    : 'Don\'t have an account? Sign Up',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
