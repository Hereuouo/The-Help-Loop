import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/skill.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final TextEditingController _skillNameController = TextEditingController();
  final TextEditingController _skillLevelController = TextEditingController();
  final TextEditingController _skillDescriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveSkill() async {
    final String skillName = _skillNameController.text.trim();
    final String skillLevel = _skillLevelController.text.trim();
    final String skillDescription = _skillDescriptionController.text.trim();
    final String userId = _auth.currentUser?.uid ?? '';

    if (skillName.isEmpty || skillLevel.isEmpty || skillDescription.isEmpty) {
      _showSnackbar('All fields are required.', isError: true);
      return;
    }

    try {
      Skill newSkill = Skill(
        name: skillName,
        description: skillDescription,
        level: skillLevel,
      );

      await _firestore.collection('skills').add({
        ...newSkill.toMap(),
        'userId': userId,
      });

      _showSnackbar('Skill added successfully!', isError: false);


      _skillNameController.clear();
      _skillLevelController.clear();
      _skillDescriptionController.clear();

    } catch (e) {
      _showSnackbar('Error: ${e.toString()}', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Skill'),
          backgroundColor: Colors.blueGrey,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add New Skill',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _skillNameController,
                          decoration: InputDecoration(
                            labelText: 'Skill Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          items: ['Beginner', 'Mid', 'Advanced']
                              .map((level) => DropdownMenuItem(
                            value: level,
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(level),
                          ))
                              .toList(),
                          onChanged: (value) {
                            _skillLevelController.text = value ?? '';
                          },
                          decoration: InputDecoration(
                            labelText: 'Skill Level',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _skillDescriptionController,
                          decoration: InputDecoration(
                            labelText: 'Skill Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveSkill,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Save Skill'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
