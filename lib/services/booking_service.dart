
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  Future<String> bookTask(String requestId, DateTime bookedTime) async {
    try {
      DocumentSnapshot requestDoc = await FirebaseFirestore.instance.collection('requests').doc(requestId).get();
      if (requestDoc.exists) {
        Map<String, dynamic> request = requestDoc.data() as Map<String, dynamic>;
        if (request['status'] == 'Pending') {
          //new booking entry
          await FirebaseFirestore.instance.collection('bookings').add({
            'requestId': requestId,
            'bookedTime': bookedTime,
            'confirmed': false,
          });
          return "Booking Created";
        } else {
          return "Task already scheduled or unavailable";
        }
      } else {
        return "Request not found";
      }
    } catch (e) {
      return "Error booking task: $e";
    }
  }
}
