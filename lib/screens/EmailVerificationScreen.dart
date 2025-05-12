import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'home_screen.dart'; 

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final String _verificationCode = '';
  bool _isCodeSent = false;
  final bool _isEmailVerified = false;

  Future<void> _sendVerificationCode() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        // Send the verification code via email (Firebase handles this)
        await user.sendEmailVerification();
        setState(() {
          _isCodeSent = true;
        });
      }
    } catch (e) {
      print("Error sending verification code: $e");
    }
  }

  Future<void> _verifyCode() async {
    // Check if email is verified
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // If the email is verified, navigate to the Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()), // Navigate to HomeScreen
      );
    } else {
      // Handle error if verification fails
      print("Verification failed or email not verified.");
    }
  }

  @override
  void initState() {
    super.initState();
    _sendVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Verify your email",
                style: FontStyles.heading(context, fontSize: 32, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _isCodeSent
                  ? Column(
                      children: [
                        TextField(
                          controller: _codeController,
                          style: FontStyles.body(context, color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Enter the verification code",
                            labelStyle: FontStyles.body(context, color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _verifyCode,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blueAccent.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Verify",
                            style: FontStyles.body(context, fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
