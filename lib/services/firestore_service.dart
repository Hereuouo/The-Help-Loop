import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/skill.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> addSkill(Skill skill) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");


    await _db
        .collection('users')
        .doc(user.uid)
        .collection('skills')
        .add(skill.toMap());
  }


  Future<void> updateSkill(Skill skill) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    if (skill.id!.isNotEmpty) {

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('skills')
          .doc(skill.id)
          .update(skill.toMap());
    } else {
      throw Exception("Skill ID is empty. Cannot update.");
    }
  }


  Future<List<Skill>> getSkills() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final snapshot = await _db
        .collection('users')
        .doc(user.uid)
        .collection('skills')
        .get();


    return snapshot.docs
        .map((doc) => Skill.fromMap(doc.data(), doc.id))
        .toList();
  }
}
