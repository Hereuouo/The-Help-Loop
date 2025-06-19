import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../global_constants.dart';
import '../widgets/custom_elevated_button.dart';
import '../generated/l10n.dart';
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


  Future<void> _saveSkills() async {
    final customSkill = _customSkillController.text.trim();
    if (customSkill.isNotEmpty) {
      _selectedSkills.add(customSkill);
    }

    if (_selectedSkills.isEmpty) {
      _showSnackbar(S.of(context).pleaseSelectSkills, isError: true);
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
        _showSnackbar(S.of(context).noNewSkillsToAdd, isError: true);
        return;
      }

      await userRef.update({
        'skills': FieldValue.arrayUnion(newSkills.toList()),
      });

      _showSnackbar(S.of(context).skillsAddedSuccessfully);
      _customSkillController.clear();
      setState(() => _selectedSkills.clear());
    } catch (e) {
      _showSnackbar(S.of(context).errorAddingSkills(e.toString()), isError: true);
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
      title: S.of(context).addSkills,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).chooseSuggestedSkills,
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
            Text(S.of(context).typeCustomSkill,
                style: FontStyles.heading(context, color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _customSkillController,
              style: FontStyles.body(context, color: Colors.white),
              decoration: InputDecoration(
                hintText: S.of(context).addCustomSkill,
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
                  Text(S.of(context).selectedSkills,
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
                label: S.of(context).saveSkills,
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