import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thehelploop/screens/post_verification_screen.dart';
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

  Future<void> loginUser() async {
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;


      if (user != null && !user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
        );
        return;
      }


      if (user != null) {
        final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();


        final List<dynamic>? skills = doc.data()?['skills'];


        bool hasSubcollection = false;
        if (skills == null || skills.isEmpty) {
          final sub = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('skills')
              .limit(1)
              .get();
          hasSubcollection = sub.docs.isNotEmpty;
        }

        final bool hasSkills = (skills != null && skills.isNotEmpty) || hasSubcollection;

        if (!hasSkills) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PostVerificationScreen()),
          );
        } else {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      print("Login error: $e");

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
                style: FontStyles.heading(context,
                    fontSize: 32, color: Colors.white),
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                  style: FontStyles.body(context,
                      fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
