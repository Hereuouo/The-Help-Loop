
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingService {
  Future<String> updateTaskStatus(String requestId, String newStatus) async {
    try {
      DocumentSnapshot requestDoc = await FirebaseFirestore.instance.collection('requests').doc(requestId).get();
      if (requestDoc.exists) {
        await FirebaseFirestore.instance.collection('tracking').add({
          'requestId': requestId,
          'updatedStatus': newStatus,
          'timestamp': DateTime.now(),
        });
        await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
          'status': newStatus,
        });
        return "Status updated to $newStatus";
      } else {
        return "Invalid request";
      }
    } catch (e) {
      return "Error updating task status: $e";
    }
  }
}
