import 'package:cloud_firestore/cloud_firestore.dart';

/// models/booking_request.dart
class BookingRequest {
  final String fromUserId;
  final String toUserId;
  final String requestedSkill;
  final DateTime startDate;
  final String duration;
  final String? notes;
  final GeoPoint fromLocation;
  final String fromAddress;
  final double distanceKm;
  final String status;
  final DateTime timestamp;

  BookingRequest({
    required this.fromUserId,
    required this.toUserId,
    required this.requestedSkill,
    required this.startDate,
    required this.duration,
    this.notes,
    required this.fromLocation,
    required this.fromAddress,
    required this.distanceKm,
    this.status = 'pending',
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'requestedSkill': requestedSkill,
    'startDate': startDate,
    'duration': duration,
    'notes': notes,
    'fromLocation': fromLocation,
    'fromAddress': fromAddress,
    'distanceKm': distanceKm,
    'status': status,
    'timestamp': timestamp,
  };
}
