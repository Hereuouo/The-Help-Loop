import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias for Firebase User
import '../models/skill.dart';
import '../services/firestore_service.dart';
import 'base_scaffold.dart'; 
import 'font_styles.dart'; 
import 'skill_list_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Variable to hold user data and skills
  late firebase_auth.User _user;
  late List<Skill> _skills;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchSkills();
  }

  // Method to get user data from Firebase Auth
  void _getUserData() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });
    }
  }

  // Method to fetch skills from Firestore
  void _fetchSkills() async {
    final skills = await FirestoreService().getSkills();
    setState(() {
      _skills = skills;
    });
  }

  // Update the user's display name in Firebase Auth
  Future<void> _updateDisplayName(String newName) async {
    try {
      await _user.updateProfile(displayName: newName);
      await _user.reload(); // Reload the user data to reflect the changes
      setState(() {
        _user = _auth.currentUser!;
      });
    } catch (e) {
      print("Error updating display name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: _user.displayName),
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  // Update display name when changed
                  _updateDisplayName(value);
                },
              ),
              TextField(
                controller: TextEditingController(text: _user.email),
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: false, // Disable email field for editing
              ),
              const SizedBox(height: 20),
              const Text("Your Skills:", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              _skills.isEmpty
                  ? const Text("No skills added yet.")
                  : Column(
                      children: _skills
                          .map(
                            (skill) => ListTile(
                              title: Text(skill.name),
                              subtitle: Text("${skill.description}\nLevel: ${skill.level}"),
                              onTap: () {
                                // Go to SkillListScreen to adjust skill details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SkillListScreen(),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // more user actions like saving, logging out,....
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
