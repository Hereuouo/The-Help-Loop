import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thehelploop/widgets/custom_elevated_button.dart';
import '../services/tracking_map_factory.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/rating_dialog.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'payment_requests_screen.dart';

import '../web/tracking_map_stub.dart'
    if (dart.library.html) '../web/tracking_map_web_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, String?> _statuses = {
    'All': null,
    'Pending': 'pending',
    'Payment Pending': 'payment_pending',
    'In Progress': 'in_progress',
    'Completed': 'completed',
    'Rejected': 'rejected',
  };
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'My Bookings',
      actions: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('fromUserId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .where('status', isEqualTo: 'payment_pending')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && (snapshot.data?.docs.length ?? 0) > 0) {
              return IconButton(
                icon: Badge(
                  label: Text(snapshot.data!.docs.length.toString()),
                  child: const Icon(Icons.payment, size: 28),
                ),
                tooltip: 'Payment Requests',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentRequestsScreen(),
                    ),
                  );
                },
              );
            }
            return IconButton(
              icon: const Icon(Icons.payment_outlined),
              tooltip: 'Payment Requests',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentRequestsScreen(),
                  ),
                );
              },
            );
          },
        ),
      ],
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            labelStyle: FontStyles.body(
              context,
              color: Colors.white,
              fontSize: 16,
            ),
            unselectedLabelColor: Colors.white70,
            unselectedLabelStyle: FontStyles.body(
              context,
              color: Colors.white70,
              fontSize: 16,
            ),
            isScrollable: true,
            tabs: _statuses.keys.map((status) {
              return Tab(
                child: Text(
                  status,
                  style: FontStyles.body(context,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _statuses.values.map((status) {
                return _MyBookingsTab(status: status);
              }).toList(),
            ),
          ),
        ],
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
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookings = snapshot.data!.docs.where((doc) {
          final docStatus = doc['status']?.toString().toLowerCase();
          if (status == null) return true;
          return docStatus == status;
        }).toList();

        if (bookings.isEmpty) {
          return Center(
              child: Text(
            'No bookings available.',
            style: FontStyles.body(context, color: Colors.white),
          ));
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

  Future<bool> _hasRated(BuildContext context, String bookingId,
      String fromUserId, String toUserId) async {
    final reviewSnapshot = await FirebaseFirestore.instance
        .collection('trustReviews')
        .where('reviewerId', isEqualTo: fromUserId)
        .where('reviewedUserId', isEqualTo: toUserId)
        .where('bookingId', isEqualTo: bookingId)
        .get();
    return reviewSnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final status = booking['status'].toString().toLowerCase();
    final currentUser = FirebaseAuth.instance.currentUser;
    final exchangeType = booking['exchangeType'];
    final paymentStatus = booking['paymentStatus'];

    return Card(
      color: _statusColor(status),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 Location: ${booking['fromAddress']}',
                style: FontStyles.body(context,
                    color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
            Text('🧠 Skill: ${booking['requestedSkill']}',
                style: FontStyles.body(context, color: Colors.black)),
            if (exchangeType == 'skill')
              Text(
                  '🔄 Exchange: ${booking['exchangedSkill'] ?? 'Skill exchange'}',
                  style: FontStyles.body(context,
                      color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            if (exchangeType == 'fee')
              Text(
                  '💰 Fee: ${booking['feeAmount']?.toStringAsFixed(2) ?? '0.00'}',
                  style: FontStyles.body(context,
                      color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            if (paymentStatus != null)
              Text('💳 Payment: ${_capitalize(paymentStatus)}',
                  style: FontStyles.body(context,
                      color: paymentStatus == 'completed'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold)),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(booking['toUserId'])
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return Text('👤 Loading provider name...',
                      style: FontStyles.body(context, color: Colors.black));
                }
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;
                final providerName = userData != null
                    ? userData['name'] ?? 'Unknown'
                    : 'Unknown';
                return Text('👤 Skill Provider: $providerName',
                    style: FontStyles.body(context, color: Colors.black));
              },
            ),
            Text(
                '📅 Requested on: ${booking['timestamp'].toDate().toString().split(" ")[0]}',
                style: FontStyles.body(context, color: Colors.black)),
            Text(
                '📅 Start Date: ${booking['startDate'].toDate().toString().split(" ")[0]}',
                style: FontStyles.body(context, color: Colors.black)),
            Text('⌛ Duration: ${booking['duration']}',
                style: FontStyles.body(context, color: Colors.black)),
            Text(
                '📝 Notes: ${booking['notes']?.toString().isNotEmpty == true ? booking['notes'] : 'No notes'}',
                style: FontStyles.body(context, color: Colors.black)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                    label: Text('Status: ${_capitalize(status)}',
                        style: FontStyles.body(context, color: Colors.black))),
                if (status == 'payment_pending')
                  CustomElevatedButton(
                    icon: Icons.payment,
                    label: 'View Payment Request',
                    style: FontStyles.heading(context,
                        fontSize: 16, color: Colors.white),
                    backgroundColor: Colors.amber.shade700,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentRequestsScreen(),
                        ),
                      );
                    },
                  ),
                if (status == 'in_progress')
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: Text('Track',
                        style: FontStyles.body(context, color: Colors.black)),
                    onPressed: () =>
                        _openTrackingMap(context, booking['toUserId']),
                  ),
                if (status == 'pending')
                  CustomElevatedButton(
                    icon: Icons.cancel_outlined,
                    label: 'Cancel',
                    style: FontStyles.heading(context,
                        fontSize: 16, color: Colors.white),
                    backgroundColor: Colors.red,
                    onPressed: () {
                      _confirmCancel(context, booking.id);
                    },
                  ),
                if (status == 'completed')
                  FutureBuilder<bool>(
                    future: _hasRated(context, booking.id, currentUser!.uid,
                        booking['toUserId']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      final hasRated = snapshot.data ?? false;
                      if (hasRated) return const SizedBox.shrink();
                      return CustomElevatedButton(
                        icon: Icons.star,
                        label: 'Rate the Service',
                        style: FontStyles.heading(context,
                            fontSize: 16, color: Colors.white),
                        backgroundColor: Colors.teal,
                        onPressed: () async {
                          await showRatingDialog(
                            context: context,
                            userIdToRate: booking['toUserId'],
                            bookingId: booking.id,
                          );
                        },
                      );
                    },
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
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'rejected',
        'rejectionReason': 'Cancelled by requester',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking cancelled',
              style: FontStyles.body(context, color: Colors.white)),
        ),
      );
    }
  }

  void _openTrackingMap(BuildContext context, String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final geo = doc['location'] as GeoPoint?;
    if (geo == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No location available',
              style: FontStyles.body(context, color: Colors.white))));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingMapFactory.create(
          userLocation: LatLng(geo.latitude, geo.longitude),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade200;
      case 'payment_pending':
        return Colors.yellow.shade200;
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
