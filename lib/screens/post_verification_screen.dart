import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thehelploop/services/user_service.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class PostVerificationScreen extends StatefulWidget {
  const PostVerificationScreen({super.key});

  @override
  State<PostVerificationScreen> createState() => _PostVerificationScreenState();
}

class _PostVerificationScreenState extends State<PostVerificationScreen> {
  final List<String> predefinedSkills = [
    "Graphic Design",
    "Translation",
    "Programming",
    "Childcare",
    "Device Repair",
    "Private Tutoring",
    "Photography",
    "Writing",
    "Video Editing",
    "Web Development",
    "Marketing",
    "Cooking",
    "Gardening",
    "Painting",
    "Carpentry",
    "Sewing",
    "Fitness Training",
    "Music Lessons",
    "Event Planning",
    "Accounting",
  ];

  final TextEditingController customSkillController = TextEditingController();
  final Set<String> selectedSkills = {};
  bool? isWillingToPay;

  final UserService _userService = UserService();

  void _toggleSkill(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });
  }

  Future<void> _submitData() async {
    if (isWillingToPay == null) {
      _showDialog(
        title: "Selection Required",
        message: "Please indicate if you are willing to pay a fee.",
      );
      return;
    }

    if (!isWillingToPay!) {
      _showDialog(
        title: "Sorry",
        message:
            "Sorry, you won’t be able to use the app without agreeing to the terms. Thank you!",
        onClose: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final allSkills = [...selectedSkills];
      final custom = customSkillController.text.trim();
      if (custom.isNotEmpty) allSkills.add(custom);

      await _userService.updateSkillsAndPaymentConsent(
          user.uid, allSkills, true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      _showDialog(
        title: "Error",
        message: "An error occurred while saving data. Please try again later.",
      );
    }
  }

  void _showDialog(
      {required String title, required String message, VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title,
            textAlign: TextAlign.center,
            style: FontStyles.heading(context, fontSize: 20)),
        content: Text(message,
            textAlign: TextAlign.center, style: FontStyles.body(context)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onClose != null) onClose();
            },
            child:
                Text("OK", style: FontStyles.body(context, color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Select Your Skills",
              style: FontStyles.heading(context,
                  fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: predefinedSkills.map((skill) {
                final bool selected = selectedSkills.contains(skill);

                return ChoiceChip(
                  label: Text(
                    skill,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  selected: selected,
                  selectedColor: Colors.greenAccent.shade400,
                  backgroundColor: Colors.white,
                  pressElevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onSelected: (_) => _toggleSkill(skill),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customSkillController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Add a custom skill",
                labelStyle: const TextStyle(color: Colors.white70),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Are you willing to pay a small fee to receive services if you don’t have skills to exchange?",
              style: FontStyles.body(context, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RadioListTile<bool>(
                    title: Text("Yes",
                        style: FontStyles.body(context, color: Colors.white)),
                    value: true,
                    groupValue: isWillingToPay,
                    onChanged: (val) => setState(() => isWillingToPay = val),
                    activeColor: Colors.green,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Flexible(
                  child: RadioListTile<bool>(
                    title: Text("No",
                        style: FontStyles.body(context, color: Colors.white)),
                    value: false,
                    groupValue: isWillingToPay,
                    onChanged: (val) => setState(() => isWillingToPay = val),
                    activeColor: Colors.red,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedSkills.isNotEmpty ||
                      customSkillController.text.isNotEmpty
                  ? _submitData
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
