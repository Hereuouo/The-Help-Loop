import 'package:flutter/material.dart';  
import 'package:firebase_auth/firebase_auth.dart';  
import 'package:cloud_firestore/cloud_firestore.dart';  
import 'base_scaffold.dart';  
import 'EmailVerificationScreen.dart';  
import 'font_styles.dart'; // Import the custom font styles  

class RegisterScreen extends StatefulWidget {  
  const RegisterScreen({super.key});  

  @override  
  State<RegisterScreen> createState() => _RegisterScreenState();  
}  

class _RegisterScreenState extends State<RegisterScreen> {  
  final emailController = TextEditingController();  
  final passwordController = TextEditingController();  
  final nameController = TextEditingController();  
  int? age; // initially null  
  String? gender; // initially null  

  // Function to validate email format  
  bool isValidEmail(String email) {  
    //  regex for email validation  
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');  
    return regex.hasMatch(email);  
  }  

  // Function to show alert dialog for errors  
  void showErrorDialog(String message) {  
    showDialog(  
      context: context,  
      builder: (BuildContext context) {  
        return AlertDialog(  
          backgroundColor: Colors.white.withOpacity(0.9), // Soft white background  
          content: Container(  
            padding: const EdgeInsets.all(16),  
            child: Center(  
              child: Column(  
                mainAxisSize: MainAxisSize.min, // Make dialog size wrap content  
                children: [  
                  // Adjusted Text widget without textAlign  
                  Text(  
                    message,  
                    style: FontStyles.body(context, color: Colors.red).copyWith(  
                      fontWeight: FontWeight.bold,  
                      fontSize: 16,  
                    ),  
                    textAlign: TextAlign.center, // Set the text alignment here  
                  ),  
                  const SizedBox(height: 12), // Space between message and button  
                  TextButton(  
                    onPressed: () {  
                      Navigator.of(context).pop(); // Close the dialog  
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

  // Function to register user and save additional information to Firestore  
  Future<void> registerUser() async {  
    // Validate inputs  
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

    try {  
      // Register the user with Firebase Authentication  
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(  
        email: emailController.text.trim(),  
        password: passwordController.text.trim(),  
      );  

      // Get the current user ID  
      String userId = userCredential.user!.uid;  

      // Save the additional information to Firestore  
      await FirebaseFirestore.instance.collection('users').doc(userId).set({  
        'name': nameController.text.trim(),  
        'email': emailController.text.trim(),  
        'age': age,   
        'gender': gender,  
        'trustScore': 'unavailable', //'unavailable' initially  
      });  

      // Send the verification email 
      await userCredential.user!.sendEmailVerification();  

      // registration was successful  
      ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(content: Text('Registration successful! A verification email has been sent.')),  
      );  

      // Navigate to EmailVerificationScreen after successful registration  
      Navigator.pushReplacement(  
        context,  
        MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),  
      );  
    } catch (e) {  
      print("Firebase Auth Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));  
    }  
  }  

  @override  
  Widget build(BuildContext context) {  
    return BaseScaffold(  
      child: Center( 
        child: SingleChildScrollView( //  scroll support for smaller screens  
          child: Padding(  
            padding: const EdgeInsets.all(16),  
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: <Widget>[  
                // Name Field  
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

                // Email Field  
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

                // Password Field  
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

                // Age Selection  
                Row(  
                  mainAxisAlignment: MainAxisAlignment.start,  
                  children: [  
                    Text(  
                      age != null ? "Age: $age" : "Age: Not selected",  
                      style: FontStyles.body(context, color: Colors.white),  
                    ),  
                    const SizedBox(width: 8),  
                    // Increment and Decrement Buttons  
                    Row(  
                      children: [  
                        InkWell(  
                          borderRadius: BorderRadius.circular(8.0),  
                          onTap: () {  
                            setState(() {  
                              // Adjust age with null checks  
                              if (age == null || age! > 18) {  
                                age = (age ?? 18) - 1; // Decrement if above 18  
                              }  
                            });  
                          },  
                          child: Container(  
                            padding: const EdgeInsets.all(4),  
                            decoration: BoxDecoration(  
                              color: Colors.white,   
                              borderRadius: BorderRadius.circular(8.0),  
                            ),  
                            child: const Icon(Icons.remove, color: Color.fromARGB(255, 121, 135, 197), size: 16),   
                          ),  
                        ),  
                        const SizedBox(width: 4), 
                        InkWell(  
                          borderRadius: BorderRadius.circular(8.0),  
                          onTap: () {  
                            setState(() {  
                              // Adjust age with null checks  
                              if (age == null || age! < 100) {  
                                age = (age ?? 18) + 1; // Increment if below 100  
                              }  
                            });  
                          },  
                          child: Container(  
                            padding: const EdgeInsets.all(4),  
                            decoration: BoxDecoration(  
                              color: Colors.white,   
                              borderRadius: BorderRadius.circular(8.0),  
                            ),  
                            child: const Icon(Icons.add, color: Color.fromARGB(255, 134, 148, 209), size: 16),   
                          ),  
                        ),  
                      ],  
                    ),  
                  ],  
                ),  
                const SizedBox(height: 16),  

                // Gender Label and Selection  
                Text(  
                  "Gender",  
                  style: FontStyles.body(context, color: Colors.white70), 
                ),  
                DropdownButton<String>(  
                  value: gender,  
                  icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 20),
                  style: FontStyles.body(context, color: Colors.white),
                  dropdownColor: const Color.fromARGB(255, 110, 133, 197), // Make dropdown background color  
                  underline: Container(  
                    height: 2,  
                    color: Colors.grey,  
                  ),  
                  items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {  
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
                      gender = newValue; // Update selected gender  
                    });  
                  },  
                  hint: Text(  
                    'Select Gender',  
                    style: FontStyles.body(context, color: Colors.white70), 
                  ),  
                ),  
                const SizedBox(height: 20), 

                // Sign Up Button  
                Center( // Center  
                  child: ElevatedButton(  
                    style: ElevatedButton.styleFrom(  
                      backgroundColor: Colors.transparent, // background empty  
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), 
                      textStyle: FontStyles.body(context, color: Colors.white).copyWith(  
                        fontSize: 20,   
                        fontWeight: FontWeight.bold,  
                      ),  
                    ),  
                    onPressed: () async {  
                      await registerUser(); // Call registerUser   
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