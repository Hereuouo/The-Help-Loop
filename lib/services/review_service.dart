
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  Future<String> submitTrustReview(String reviewerId, String reviewedUserId, int rating, String comment) async {
    try {
      await FirebaseFirestore.instance.collection('trustReviews').add({
        'reviewerId': reviewerId,
        'reviewedUserId': reviewedUserId,
        'rating': rating,
        'comment': comment,
        'createdAt': DateTime.now(),
      });

      // Update trust score 
      await FirebaseFirestore.instance.collection('users').doc(reviewedUserId).update({
        'trustScore': FieldValue.increment(rating / 5.0), // Example of updating trust score
      });

      return "Review submitted";
    } catch (e) {
      return "Error submitting review: $e";
    }
  }

  Future<String> submitTaskReview(String requestId, int rating, String comment) async {
    try {
      await FirebaseFirestore.instance.collection('taskReviews').add({
        'requestId': requestId,
        'rating': rating,
        'comment': comment,
        'createdAt': DateTime.now(),
      });
      return "Task review submitted";
    } catch (e) {
      return "Error submitting task review: $e";
    }
  }
}
