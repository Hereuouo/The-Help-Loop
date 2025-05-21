import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/confirm_dialog.dart';
import 'base_scaffold.dart';
import 'tracking_map_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final Map<String, String?> _statuses = {
    'All': null,
    'Pending': 'pending',
    'In Progress': 'in_progress',
    'Completed': 'completed',
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _statuses.length,
      child: BaseScaffold(
        title: 'My Bookings',
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: _statuses.keys.map((status) => Tab(text: status)).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: _statuses.values.map((status) {
            return _MyBookingsTab(status: status);
            }).toList(),

      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyBookingsTab extends StatelessWidget {
  final String? status;
  const _MyBookingsTab({this.status});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('fromUserId', isEqualTo: currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final bookings = snapshot.data!.docs.where((doc) {
          final docStatus = doc['status']?.toString().toLowerCase();
          if (status == null) return true;
          return docStatus == status;
        }).toList();

        if (bookings.isEmpty) {
          return const Center(child: Text('No bookings available.'));
        }

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _MyBookingCard(booking: booking);
          },
        );
      },
    );
  }
}

class _MyBookingCard extends StatelessWidget {
  final QueryDocumentSnapshot booking;
  const _MyBookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking['status'].toString().toLowerCase();

    return Card(
      color: _statusColor(status),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 Location: ${booking['fromAddress']}'),
            Text('🧠 Skill: ${booking['requestedSkill']}'),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(booking['toUserId'])
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Text('👤 Loading provider name...');
                }
                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                final providerName = userData != null
                    ? userData['name'] ?? 'Unknown'
                    : 'Unknown';
                return Text('👤 Skill Provider: $providerName');
              },
            ),
            Text('📅 Requested on: ${booking['timestamp'].toDate().toString().split(" ")[0]}'),
            Text('📅 Start Date: ${booking['startDate'].toDate().toString().split(" ")[0]}'),
            Text('⌛ Duration: ${booking['duration']}'),
            Text('📝 Notes: ${booking['notes']?.toString().isNotEmpty == true ? booking['notes'] : 'No notes'}'),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(label: Text('Status: ${_capitalize(status)}')),
                const Spacer(),
                if (status == 'in_progress')
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Track'),
                    onPressed: () => _openTrackingMap(context, booking['toUserId']),
                  ),
                const SizedBox(width: 8),
                if (status == 'pending')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Cancel'),
                    onPressed: () => _confirmCancel(context, booking.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, String bookingId) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Cancel Booking',
      message: 'Are you sure you want to cancel this booking?',
      cancelText: 'Back',
      confirmText: 'Cancel',
      confirmColor: Colors.teal,
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled')),
      );
    }
  }
  void _openTrackingMap(BuildContext context, String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final geo = doc['location'] as GeoPoint?;
    if (geo == null) return;

    Navigator.push(context, MaterialPageRoute(
      builder: (_) => TrackingMapScreen(
        userLocation: LatLng(geo.latitude, geo.longitude),
      ),
    ));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade200;
      case 'in_progress':
        return Colors.blue.shade200;
      case 'completed':
        return Colors.green.shade200;
      case 'rejected':
        return Colors.grey.shade400;
      default:
        return Colors.grey.shade200;
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}
