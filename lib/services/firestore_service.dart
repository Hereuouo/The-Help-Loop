import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/skill.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to add a skill to the current user's profile
  Future<void> addSkill(Skill skill) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    // Add skill to Firestore under the current user's skills collection
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('skills')
        .add(skill.toMap());
  }

  // Method to update an existing skill of the current user
  Future<void> updateSkill(Skill skill) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    if (skill.id!.isNotEmpty) {
      // Update the skill in Firestore under the user's skills collection
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('skills')
          .doc(skill.id) // Use the skill's document ID to update it
          .update(skill.toMap());
    } else {
      throw Exception("Skill ID is empty. Cannot update.");
    }
  }

  // Method to fetch all skills of the current user
  Future<List<Skill>> getSkills() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final snapshot = await _db
        .collection('users')
        .doc(user.uid)
        .collection('skills')
        .get();

    // Convert each document in the collection to a Skill object
    return snapshot.docs
        .map((doc) => Skill.fromMap(doc.data(), doc.id))
        .toList();
  }
}
