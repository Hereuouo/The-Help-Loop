import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/custom_elevated_button.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _customSkillController = TextEditingController();
  final Set<String> _selectedSkills = {};

  final List<String> predefinedSkills = [
    "Graphic Design", "Translation", "Programming", "Childcare", "Device Repair",
    "Private Tutoring", "Photography", "Writing", "Video Editing", "Web Development",
    "Marketing", "Cooking", "Gardening", "Painting", "Carpentry", "Sewing",
    "Fitness Training", "Music Lessons", "Event Planning", "Accounting"
  ];

  Future<void> _saveSkills() async {
    final customSkill = _customSkillController.text.trim();
    if (customSkill.isNotEmpty) {
      _selectedSkills.add(customSkill);
    }

    if (_selectedSkills.isEmpty) {
      _showSnackbar('Please select or enter at least one skill.', isError: true);
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final userRef = _firestore.collection('users').doc(user.uid);
      final currentSkills = (await userRef.get())
          .data()?['skills'] as List? ??
          [];

      final newSkills = _selectedSkills.where(
            (skill) => !currentSkills.contains(skill),
      );

      if (newSkills.isEmpty) {
        _showSnackbar('No new skills to add.', isError: true);
        return;
      }

      await userRef.update({
        'skills': FieldValue.arrayUnion(newSkills.toList()),
      });

      _showSnackbar('Skills added successfully!');
      _customSkillController.clear();
      setState(() => _selectedSkills.clear());
    } catch (e) {
      _showSnackbar('Error: $e', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Add Skills',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose from suggested skills:',
                style: FontStyles.heading(context, color: Colors.white, fontSize: 20)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: predefinedSkills.map((skill) {
                final selected = _selectedSkills.contains(skill);
                return ChoiceChip(
                  label: Text(skill),
                  selected: selected,
                  selectedColor: Colors.tealAccent,
                  backgroundColor: Colors.white,
                  labelStyle: FontStyles.body(
                    context,
                    color: selected ? Colors.black : Colors.black87,
                  ),
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        _selectedSkills.remove(skill);
                      } else {
                        _selectedSkills.add(skill);
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Or type your own skill:',
                style: FontStyles.heading(context, color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _customSkillController,
              style: FontStyles.body(context, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add Custom Skill',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    _selectedSkills.add(value.trim());
                    _customSkillController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            if (_selectedSkills.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selected Skills:',
                      style: FontStyles.heading(context, fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _selectedSkills
                        .map((skill) => Chip(
                      label: Text(skill,
                        style: FontStyles.body(context,
                            fontSize: 18, color: Colors.black),),
                      onDeleted: () {
                        setState(() => _selectedSkills.remove(skill));
                      },
                      deleteIcon: const Icon(Icons.cancel, color: Colors.red),
                      backgroundColor: Colors.teal.shade100,
                    ))
                        .toList(),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                icon: Icons.save,
                label: 'Save Skills',
                style: FontStyles.heading(context,
                    fontSize: 18, color: Colors.white),
                onPressed: _saveSkills,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
