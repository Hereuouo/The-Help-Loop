import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class BackfillService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> predefinedSkills = [
    "Graphic Design", "Translation", "Programming", "Childcare", "Device Repair",
    "Private Tutoring", "Photography", "Writing", "Video Editing", "Web Development",
    "Marketing", "Cooking", "Gardening", "Painting", "Carpentry", "Sewing",
    "Fitness Training", "Music Lessons", "Event Planning", "Accounting"
  ];

  Future<void> runBackfillForUsers() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final random = Random();

      for (final doc in usersSnapshot.docs) {
        final data = doc.data();
        List<String> skills = [];


        if (data['skills'] != null && data['skills'] is List && (data['skills'] as List).isNotEmpty) {
          skills = List<String>.from(data['skills']);
        } else {

          skills = List.generate(3, (_) => predefinedSkills[random.nextInt(predefinedSkills.length)]);
          await doc.reference.update({'skills': skills});
        }

        final input = skills.join(', ');
        await doc.reference.update({
          'input': input,
          'status': {
            'firestore-vector-search': {
              'state': 'COMPLETED'
            }
          },
          'searchHistory': [],
          'willingToPay':true,
        });
      }

      print('Backfill complete for all users.');
    } catch (e) {
      print('Error during backfill: $e');
    }
  }
}
