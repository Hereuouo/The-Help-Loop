
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<String> updateUserTrustScore(String userId, double trustScore) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'trustScore': trustScore,
      });
      return "User trust score updated";
    } catch (e) {
      return "Error updating user trust score: $e";
    }
  }
}
