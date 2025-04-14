import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_scaffold.dart'; 
import 'EmailVerificationScreen.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

  // Register user and save additional information to Firestore
  Future<void> registerUser() async {
    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the current user ID
      String userId = userCredential.user!.uid;

      // Save the additional information to Firestore with trustScore set to 'unavailable'
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'age': ageController.text.trim(),
        'gender': genderController.text.trim(),
        'trustScore': 'unavailable',  // Set the trust score as 'unavailable' initially
      });

      // Send the verification email to the user
      await userCredential.user!.sendEmailVerification();

      // Show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful! A verification email has been sent.')),
      );

      // Go to EmailVerificationScreen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmailVerificationScreen()), // Navigate to EmailVerificationScreen
      );
    } catch (e) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age")),
            TextField(controller: genderController, decoration: const InputDecoration(labelText: "Gender")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
