
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:the_help_loop_master/screens/post_verification_screen.dart';
import 'package:the_help_loop_master/generated/l10n.dart';
import 'package:the_help_loop_master/providers/locale_provider.dart';
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
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

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

        final bool hasSkills =
            (skills != null && skills.isNotEmpty) || hasSubcollection;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).loginError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLanguage = localeProvider.locale.languageCode;

    return BaseScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Text(
                S.of(context).login,
                style: FontStyles.heading(context,
                    fontSize: 32, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),


              TextField(
                controller: emailController,
                style: FontStyles.body(context, color: Colors.white),
                decoration: InputDecoration(
                  labelText: S.of(context).email,
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
                  labelText: S.of(context).password,
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
                  S.of(context).loginButton,
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