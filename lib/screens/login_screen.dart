import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'EmailVerificationScreen.dart'; 
import 'home_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Method to handle user login
  Future<void> loginUser() async {
    try {
      // Attempt to sign in the user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is verified
      if (user != null && !user.emailVerified) {
        // If not verified, go to the verification screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
        );
      } else {
        // If verified, go to the correct home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print("Login error: $e");
      // Handle error, show a message to the user
    }
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
                "Login",
                style: FontStyles.heading(context, fontSize: 32, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                style: FontStyles.body(context, color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: FontStyles.body(context, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: FontStyles.body(context, color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: FontStyles.body(context, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Login",
                  style: FontStyles.body(context, fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
