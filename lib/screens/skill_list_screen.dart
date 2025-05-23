import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../services/firestore_service.dart';
import 'base_scaffold.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class SkillListScreen extends StatefulWidget {
  final Skill? skillToEdit;

  const SkillListScreen({super.key, this.skillToEdit});

  @override
  _SkillListScreenState createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  final TextEditingController skillController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedSkillLevel = "Beginner";

  @override
  void initState() {
    super.initState();
    if (widget.skillToEdit != null) {

      skillController.text = widget.skillToEdit!.name;
      descriptionController.text = widget.skillToEdit!.description;
      selectedSkillLevel = widget.skillToEdit!.level;
    }
  }


  Future<void> addOrUpdateSkill() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final skill = Skill(
        id: widget.skillToEdit?.id ?? '',
        name: skillController.text.trim(),
        description: descriptionController.text.trim(),
        level: selectedSkillLevel,
      );

      try {
        if (widget.skillToEdit == null) {
          // Add new skill if no existing skill is being edited
          await FirestoreService().addSkill(skill);
        } else {
          // Update the existing skill
          await FirestoreService().updateSkill(skill);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Skill saved successfully!')));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user logged in')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.skillToEdit == null ? 'Add Skill' : 'Edit Skill'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: skillController,
                decoration: const InputDecoration(labelText: 'Skill Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              DropdownButton<String>(
                value: selectedSkillLevel,
                onChanged: (newLevel) {
                  setState(() {
                    selectedSkillLevel = newLevel!;
                  });
                },
                items: <String>['Beginner', 'Mid', 'Advanced']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addOrUpdateSkill,
                child: Text(widget.skillToEdit == null ? 'Add Skill' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
