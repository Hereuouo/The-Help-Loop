import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_help_loop_master/widgets/custom_elevated_button.dart';
import '../services/tracking_map_factory.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/rating_dialog.dart';
import '../generated/l10n.dart';
import 'base_scaffold.dart';
import 'chat_screen.dart';
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
  late TabController _tabController;
  late Map<String, String?> _statuses;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _statuses = {
      S.of(context).allBookings: null,
      S.of(context).pendingBookings: 'pending',
      S.of(context).paymentPendingBookings: 'payment_pending',
      S.of(context).inProgressBookings: 'in_progress',
      S.of(context).completedBookings: 'completed',
      S.of(context).rejectedBookings: 'rejected',
    };

    return BaseScaffold(
      title: S.of(context).myBookings,
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
                tooltip: S.of(context).paymentRequests,
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
              tooltip: S.of(context).paymentRequests,
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
            S.of(context).noBookingsAvailable,
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

  Stream<int> _getUnreadMessagesCount(String bookingId, String currentUserId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(bookingId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      int unreadCount = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final readBy = List<String>.from(data['readBy'] ?? []);
        if (!readBy.contains(currentUserId)) {
          unreadCount++;
        }
      }
      return unreadCount;
    });
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
            Text('📍 ${S.of(context).location}: ${booking['fromAddress']}',
                style: FontStyles.body(context,
                    color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
            Text('🧠 ${S.of(context).skill}: ${booking['requestedSkill']}',
                style: FontStyles.body(context, color: Colors.black)),
            if (exchangeType == 'skill')
              Text(
                  '🔄 ${S.of(context).exchange}: ${booking['exchangedSkill'] ?? S.of(context).skillExchange}',
                  style: FontStyles.body(context,
                      color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            if (exchangeType == 'fee')
              Text(
                  '💰 ${S.of(context).fee}: \$${booking['feeAmount']?.toStringAsFixed(2) ?? '0.00'}',
                  style: FontStyles.body(context,
                      color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            if (paymentStatus != null)
              Text(
                  '💳 ${S.of(context).payment}: ${_getLocalizedPaymentStatus(context, paymentStatus)}',
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
                  return Text('👤 ${S.of(context).loading}',
                      style: FontStyles.body(context, color: Colors.black));
                }
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;
                final providerName = userData != null
                    ? userData['name'] ?? S.of(context).unknown
                    : S.of(context).unknown;
                return Text('👤 ${S.of(context).skillProvider}: $providerName',
                    style: FontStyles.body(context, color: Colors.black));
              },
            ),
            Text(
                '📅 ${S.of(context).requestedOn}: ${booking['timestamp'].toDate().toString().split(" ")[0]}',
                style: FontStyles.body(context, color: Colors.black)),
            Text(
                '📅 ${S.of(context).startDate}: ${booking['startDate'].toDate().toString().split(" ")[0]}',
                style: FontStyles.body(context, color: Colors.black)),
            Text('⌛ ${S.of(context).duration}: ${booking['duration']}',
                style: FontStyles.body(context, color: Colors.black)),
            Text(
                '📝 ${S.of(context).notes}: ${booking['notes']?.toString().isNotEmpty == true ? booking['notes'] : S.of(context).noNotes}',
                style: FontStyles.body(context, color: Colors.black)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                    label: Text(
                        '${S.of(context).status}: ${_getLocalizedStatus(context, status)}',
                        style: FontStyles.body(context, color: Colors.black))),
                if (status == 'payment_pending')
                  CustomElevatedButton(
                    icon: Icons.payment,
                    label: S.of(context).viewPaymentRequest,
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
                StreamBuilder<int>(
                  stream: _getUnreadMessagesCount(booking.id, currentUser!.uid),
                  builder: (context, snapshot) {
                    final unreadCount = snapshot.data ?? 0;

                    return Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat_bubble_outline,
                              color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  bookingId: booking.id,
                                  toUserId:
                                      booking['fromUserId'] == currentUser.uid
                                          ? booking['toUserId']
                                          : booking['fromUserId'],
                                ),
                              ),
                            );
                          },
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                unreadCount > 99
                                    ? '99+'
                                    : unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                if (status == 'in_progress')
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: Text(S.of(context).track,
                        style: FontStyles.body(context, color: Colors.black)),
                    onPressed: () =>
                        _openTrackingMap(context, booking['toUserId']),
                  ),
                if (status == 'pending')
                  CustomElevatedButton(
                    icon: Icons.cancel_outlined,
                    label: S.of(context).cancelBooking,
                    style: FontStyles.heading(context,
                        fontSize: 16, color: Colors.white),
                    backgroundColor: Colors.red,
                    onPressed: () {
                      _confirmCancel(context, booking.id);
                    },
                  ),
                if (status == 'completed')
                  FutureBuilder<bool>(
                    future: _hasRated(context, booking.id, currentUser.uid,
                        booking['toUserId']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      final hasRated = snapshot.data ?? false;
                      if (hasRated) return const SizedBox.shrink();
                      return CustomElevatedButton(
                        icon: Icons.star,
                        label: S.of(context).rateTheService,
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
      title: S.of(context).cancelBookingTitle,
      message: S.of(context).cancelBookingMessage,
      cancelText: S.of(context).back,
      confirmText: S.of(context).cancelBooking,
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
          content: Text(S.of(context).bookingCancelled,
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
          content: Text(S.of(context).noLocationAvailableForTracking,
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

  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status) {
      case 'pending':
        return S.of(context).statusPending;
      case 'payment_pending':
        return S.of(context).statusPaymentPending;
      case 'in_progress':
        return S.of(context).statusInProgress;
      case 'completed':
        return S.of(context).statusCompleted;
      case 'rejected':
        return S.of(context).statusRejected;
      default:
        return status;
    }
  }

  String _getLocalizedPaymentStatus(
      BuildContext context, String paymentStatus) {
    switch (paymentStatus) {
      case 'completed':
        return S.of(context).statusCompleted;
      case 'pending':
        return S.of(context).statusPending;
      default:
        return paymentStatus;
    }
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
}
