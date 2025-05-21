import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thehelploop/screens/post_verification_screen.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isEmailSent = false;
  String _verificationMessage = "Verification email sent. Didn't receive it?";
  int _remainingSeconds = 20;
  bool _canResendEmail = false;
  Timer? _timer;
  Timer? _verificationTimer;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
    _startCountdown();
    _startVerificationCheck();
  }

  Future<void> _sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        setState(() {
          _isEmailSent = true;
          _canResendEmail = false;
        });
      } catch (e) {
        print("Error sending verification email: $e");
      }
    }
  }

  void _startCountdown() {
    _remainingSeconds = 20;
    _canResendEmail = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResendEmail = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _startVerificationCheck() {
    _verificationTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _verifyEmail();
    });
  }

  Future<void> _verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PostVerificationScreen()),
      );
    } else {
      setState(() {
        _verificationMessage = "Verification failed. Please try again.";
      });
    }
  }

  Future<void> _resendVerificationEmail() async {
    await _sendVerificationEmail();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _verificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Email Verification Sent",
                style: FontStyles.heading(context,
                    fontSize: 32, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                _verificationMessage,
                style: FontStyles.body(context, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _canResendEmail ? _resendVerificationEmail : null,
                child: Text(
                  _canResendEmail
                      ? "Send again"
                      : "Resend email in $_remainingSeconds seconds.",
                  style: FontStyles.body(
                    context,
                    color: _canResendEmail ? Colors.white : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
