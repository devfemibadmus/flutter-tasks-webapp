import 'dart:async';

import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:tasks/model.dart';

class UserPage extends StatefulWidget {
  final User user;
  final Function() onrefresh;
  const UserPage({super.key, required this.user, required this.onrefresh});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  String? studentFileIdName;
  String? govIdFileName;
  html.File? govIdFile;
  html.File? studentIdFile;
  late User user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  Future<void> verifyAccount() async {
    if (govIdFile == null || studentIdFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please upload all required files."),
          ),
        );
      }
      return;
    }
    //
  }

  void selectIDFile() {
    html.FileUploadInputElement ninInput = html.FileUploadInputElement()
      ..accept = 'application/pdf,image/*';
    ninInput.click();
    ninInput.onChange.listen((event) {
      final files = ninInput.files;
      if (files!.isNotEmpty) {
        final file = files.first;
        if (file.size > 2 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("File size exceeds 2MB."),
              ),
            );
          }
          return;
        }
        setState(() {
          studentFileIdName = file.name;
          studentIdFile = file;
        });
      }
    });
  }

  void selectGovIdFile() {
    html.FileUploadInputElement govIdInput = html.FileUploadInputElement()
      ..accept = 'application/pdf,image/*';
    govIdInput.click();
    govIdInput.onChange.listen((event) {
      final files = govIdInput.files;
      if (files!.isNotEmpty) {
        final file = files.first;
        if (file.size > 2 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("File size exceeds 2MB."),
              ),
            );
          }
          return;
        }
        setState(() {
          govIdFileName = file.name;
          govIdFile = file;
        });
      }
    });
  }

  Future<void> getPayment() async {
    setState(() {
      isLoading = true;
    });
    String payment = await fetchPayment();
    setState(() {
      isLoading = false;
    });
    if (payment.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to load payment. Please try again later."),
          ),
        );
      }
    } else {
      html.window.open(payment, '_blank');
    }
  }

  Future<void> refreshUser() async {
    await widget.onrefresh();
  }

  void logout() {
    html.window.localStorage['token'] = '';
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  void copyReferralName(String referralName) {
    Clipboard.setData(ClipboardData(text: referralName)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Referral name copied to clipboard!"),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (user.documentSubmitted && !user.isVerify) ...[
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text:
                            "Your documents are under review. Please check back later.",
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        children: const [
                          WidgetSpan(
                            child: Text(' '),
                          ),
                          WidgetSpan(
                            child: Icon(Icons.access_time, color: Colors.grey),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ] else if (!user.isVerify) ...[
                  Text(
                    "Verify Your Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "We kindly request verification to ensure that participants are qualified to contribute to training AI tasks. "
                    "This helps us maintain quality and ensures fair compensation for your valuable work. Thank you for your understanding.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Please fill out the form below:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "1: Upload a government-issued ID.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "2: Upload your student ID or educational document (PDF, JPG, PNG).",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "3: Note: There is a third-party verification service fee, not charged by us.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildUploadButton(
                    text: govIdFileName ?? "Upload Government ID",
                    onTap: selectGovIdFile,
                  ),
                  const SizedBox(height: 30),
                  _buildUploadButton(
                    text: studentFileIdName ??
                        "Upload your student ID or educational document",
                    onTap: selectIDFile,
                  ),
                  const SizedBox(height: 16),
                  _buildCheckboxRow(
                    label: "Pay verification fee (\$0.5)",
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: verifyAccount,
                      child: const Text(
                        "Verify Account",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Earn \$0.03 per person referred",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ] else ...[
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.teal.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "You're Verified",
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorErrorColor: Colors.red,
                        cursorColor: Colors.grey.shade600,
                        controller: TextEditingController(text: user.email),
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.teal.shade50,
                          hintStyle: TextStyle(color: Colors.teal.shade400),
                        ),
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        copyReferralName(user.email);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Copy",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  label: const Text("Logout",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 24),
              ],
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
      ),
    );
  }

  Widget _buildUploadButton(
      {required String text, required html.VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.teal.shade50,
          border: Border.all(color: Colors.teal.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.file_upload, color: Colors.teal),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.teal),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({required String label}) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              side: BorderSide(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          child: Checkbox(
            value: false,
            onChanged: ((value) {
              getPayment();
            }),
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }
}
