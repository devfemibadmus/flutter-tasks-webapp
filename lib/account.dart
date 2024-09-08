import 'package:flutter/material.dart';
import 'package:tasks/main.dart';
import 'package:tasks/model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool isSignUp = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

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
      style: TextStyle(color: Colors.grey.shade600),
      cursorErrorColor: Colors.red,
      cursorColor: Colors.grey.shade600,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade300),
        ),
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
      if (fullNameController.text.isEmpty ||
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

  Future<void> handleSignIn() async {
    setState(() {
      errorMessage = '';
      successMessage = '';
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage = 'Email and password are required for Sign In.';
    } else {
      Map<String, dynamic> json =
          await getUserLogin(emailController.text, passwordController.text);
      if (json.isNotEmpty && json['success'] == true) {
        User user = User.fromJson(json);
        setState(() {
          successMessage = 'Login successful!';
          errorMessage = '';
        });
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(user: user)));
        }
      } else {
        setState(
            () => errorMessage = json['message'] ?? 'something went wrong');
      }
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSignUp ? 'Create an account' : 'Sign in to your account',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset('logo.png', height: 180),
              const SizedBox(height: 50),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              if (successMessage.isNotEmpty)
                Text(
                  successMessage,
                  style: const TextStyle(color: Colors.teal),
                ),
              const SizedBox(height: 20),
              if (isSignUp) ...[
                _buildInputField(
                  controller: fullNameController,
                  label: 'Full Name',
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
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: toggleView,
                child: Text(
                  isSignUp
                      ? 'Already have an account? Sign In'
                      : 'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.teal.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
