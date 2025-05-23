import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_scaffold.dart';
import 'EmailVerificationScreen.dart';
import 'font_styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../widgets/map_picker_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  int? age;
  String? gender;
  LatLng? _pickedLocation;
  String _pickedAddress = '';


  bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          content: Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: FontStyles.body(context, color: Colors.red).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: FontStyles.body(context, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> registerUser() async {
    if (nameController.text.trim().isEmpty) {
      showErrorDialog("Name cannot be empty");
      return;
    }

    if (!isValidEmail(emailController.text.trim())) {
      showErrorDialog("Invalid email address");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      showErrorDialog("Password cannot be empty");
      return;
    }

    if (age == null) {
      showErrorDialog("Please select your age");
      return;
    }

    if (gender == null) {
      showErrorDialog("Please select your gender");
      return;
    }

    if (_pickedLocation == null || _pickedAddress.isEmpty) {
      showErrorDialog("Please select your location");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'age': age,
        'gender': gender,
        "trustScore": 0.0,
        "ratingCount": 0,
        'location': GeoPoint(_pickedLocation!.latitude, _pickedLocation!.longitude),
        'address': _pickedAddress,
      });

      await userCredential.user!.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Registration successful! A verification email has been sent.')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const EmailVerificationScreen()),
      );
    } catch (e) {
      print("Firebase Auth Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  style: FontStyles.body(context, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  style: FontStyles.body(context, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  style: FontStyles.body(context, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.white12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(
                      _pickedLocation == null ? "Choose your location" : _pickedAddress,
                      style: FontStyles.body(context, color: Colors.white),
                    ),
                    trailing: const Icon(Icons.map, color: Colors.white),
                    onTap: () async {
                      final result = await showDialog<LatLng>(
                        context: context,
                        builder: (_) => const MapPickerDialog(),
                      );
                      if (result != null) {
                        _pickedLocation = result;
                        try {
                          final placemarks = await geo.placemarkFromCoordinates(
                              result.latitude, result.longitude);

                          _pickedAddress = [
                            placemarks.first.street,
                            placemarks.first.subAdministrativeArea,
                            placemarks.first.administrativeArea
                          ].where((e) => e != null && e!.isNotEmpty).join(', ');

                          if (_pickedAddress.isEmpty) {
                            _pickedAddress = '${result.latitude}, ${result.longitude}';
                          }
                        } catch (_) {
                          _pickedAddress = '${result.latitude}, ${result.longitude}';
                        }

                        setState(() {});
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      age != null ? "Age: $age" : "Age: Not selected",
                      style: FontStyles.body(context, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            setState(() {
                              if (age == null || age! > 18) {
                                age = (age ?? 18) - 1;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.remove,
                                color: Color.fromARGB(255, 121, 135, 197),
                                size: 16),
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            setState(() {
                              if (age == null || age! < 100) {
                                age = (age ?? 18) + 1;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.add,
                                color: Color.fromARGB(255, 134, 148, 209),
                                size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Gender",
                  style: FontStyles.body(context, color: Colors.white70),
                ),
                DropdownButton<String>(
                  value: gender,
                  icon: const Icon(Icons.arrow_downward,
                      color: Colors.white, size: 20),
                  style: FontStyles.body(context, color: Colors.white),
                  dropdownColor: const Color.fromARGB(255, 110, 133, 197),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: FontStyles.body(context, color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  hint: Text(
                    'Select Gender',
                    style: FontStyles.body(context, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      textStyle: FontStyles.body(context, color: Colors.white)
                          .copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      await registerUser();
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
