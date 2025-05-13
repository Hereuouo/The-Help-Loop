import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/skill.dart';
import 'AddSkillScreen.dart';
import 'base_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = "";
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }


  Future<void> _getUserData() async {
    try {
      final email = _auth.currentUser?.email ?? '';
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        setState(() {
          _name = userData['name'] ?? "";
          _nameController.text = _name;
        });
      }
    } catch (e) {
      _showSnackbar('Error fetching user data: $e', isError: true);
    }
  }

  /// Update user name in Firestore
  Future<void> _updateName() async {
    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      _showSnackbar('Name cannot be empty.', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            title: const Text('Update Name'),
            content: const Text('Are you sure you want to update the name?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    final email = _auth.currentUser?.email ?? '';
                    final userSnapshot = await _firestore
                        .collection('users')
                        .where('email', isEqualTo: email)
                        .limit(1)
                        .get();

                    if (userSnapshot.docs.isNotEmpty) {
                      String docId = userSnapshot.docs.first.id;
                      await _firestore.collection('users').doc(docId).update({
                        'name': newName,
                      });

                      setState(() {
                        _name = newName;
                      });

                      _showSnackbar('Name updated successfully!', isError: false);
                    }
                  } catch (e) {
                    _showSnackbar('Error updating name: $e', isError: true);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Delete skill
  Future<void> _deleteSkill(String skillId) async {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            title: const Text('Delete Skill'),
            content: const Text('Are you sure you want to delete this skill?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _firestore.collection('skills').doc(skillId).delete();
                    _showSnackbar('Skill deleted successfully!', isError: false);
                  } catch (e) {
                    _showSnackbar('Error deleting skill: $e', isError: true);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show snackbar
  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            backgroundColor: Colors.blueGrey,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// User Information Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(text: _auth.currentUser?.email),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _updateName,
                        child: const Text('Update Name'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Skills Section
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('skills')
                        .where('userId', isEqualTo: _auth.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Error loading skills.'));
                      }

                      final skillDocs = snapshot.data?.docs ?? [];

                      if (skillDocs.isEmpty) {
                        return const Center(child: Text('No skills added yet.'));
                      }

                      return ListView.builder(
                        itemCount: skillDocs.length,
                        itemBuilder: (context, index) {
                          final skill = Skill.fromMap(skillDocs[index].data() as Map<String, dynamic>, skillDocs[index].id);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(skill.name),
                              subtitle: Text("${skill.description}\nLevel: ${skill.level}"),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _deleteSkill(skill.id!);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: const [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSkillScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
