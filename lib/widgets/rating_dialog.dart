import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/review.dart';
import '../screens/font_styles.dart';

Future<void> showRatingDialog({
  required BuildContext context,
  required String userIdToRate,
}) async {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: const Color(0xFFECEAFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rate the other user',
                style: FontStyles.heading(context,
                    fontSize: 22, color: Colors.black87)),
            const SizedBox(height: 12),
            StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: index < selectedRating
                            ? Colors.amber
                            : Colors.grey.shade400,
                        size: 32,
                      ),
                      onPressed: () =>
                          setState(() => selectedRating = index + 1),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: commentController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Add a comment (optional)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text('Cancel',
                      style:
                          FontStyles.body(context, color: Colors.deepPurple)),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedRating > 0) {
                      await _submitTrustReview(
                        reviewerId: FirebaseAuth.instance.currentUser!.uid,
                        reviewedUserId: userIdToRate,
                        rating: selectedRating,
                        comment: commentController.text.trim(),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Review submitted ✅')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text('Submit',
                      style: FontStyles.body(context, color: Colors.white)),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Future<void> _submitTrustReview({
  required String reviewerId,
  required String reviewedUserId,
  required int rating,
  required String comment,
}) async {
  final reviewId = const Uuid().v4();
  final review = TrustReview(
    id: reviewId,
    reviewerId: reviewerId,
    reviewedUserId: reviewedUserId,
    rating: rating,
    comment: comment,
    createdAt: DateTime.now(),
  );

  final reviewRef = FirebaseFirestore.instance.collection('trustReviews');
  final userRef = FirebaseFirestore.instance.collection('users').doc(reviewedUserId);

  try {

    await reviewRef.doc(reviewId).set(review.toMap());
    print('✅ Review added successfully: $reviewId');


    final querySnapshot = await reviewRef
        .where('reviewedUserId', isEqualTo: reviewedUserId)
        .get();

    print('📦 Total reviews fetched for user [$reviewedUserId]: ${querySnapshot.docs.length}');


    final allRatings = querySnapshot.docs.map((doc) {
      final rating = doc.data()['rating'];
      print('⭐ Found rating: $rating');
      return rating as int;
    }).toList();

    if (allRatings.isEmpty) {
      print('⚠️ No ratings found, skipping trustScore update');
      return;
    }


    final average = allRatings.reduce((a, b) => a + b) / allRatings.length;
    print('📊 Calculated trustScore average: $average');


    await userRef.update({
      'trustScore': double.parse(average.toStringAsFixed(2)),
    });

    print('✅ trustScore updated for user [$reviewedUserId]');
  } catch (e) {
    print('❌ Error in _submitTrustReview: $e');
  }
}
