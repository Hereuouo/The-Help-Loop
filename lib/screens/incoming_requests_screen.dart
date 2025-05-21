import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thehelploop/screens/tracking_map_screen.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/rating_dialog.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';

class IncomingRequestsScreen extends StatefulWidget {
  const IncomingRequestsScreen({super.key});

  @override
  State<IncomingRequestsScreen> createState() => _IncomingRequestsScreenState();
}

class _IncomingRequestsScreenState extends State<IncomingRequestsScreen> with SingleTickerProviderStateMixin {
  final currentUser = FirebaseAuth.instance.currentUser;
  final List<String> _statuses = ['All', 'pending', 'in_progress', 'completed', 'rejected'];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _statuses.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Incoming Requests',
      child: DefaultTabController(
        length: _statuses.length,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.teal.shade800,
              indicatorColor: Colors.white,
              tabs: _statuses.map((status) {
                return Tab(text: status == 'All' ? 'All' : _prettyStatus(status));
              }).toList(),            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _statuses.map((status) {
                  return _buildBookingList(status == 'All' ? null : status.toLowerCase());
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _prettyStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  Widget _buildBookingList(String? status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('toUserId', isEqualTo: currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final bookings = snapshot.data!.docs.where((doc) {
          if (status == null) return true;
          return doc['status']?.toLowerCase() == status;
        }).toList();

        if (bookings.isEmpty) {
          return const Center(child: Text('No incoming requests available.'));
        }

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final startDate = booking['startDate'].toDate();
            final duration = booking['duration'] ?? 'Day';
            final endDate = _calculateEndDate(startDate, duration);
            final status = booking['status'].toString().toLowerCase();

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(booking['fromUserId']).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const SizedBox();
                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                final name = userData?['name'] ?? 'Unknown';

                return Card(
                  color: _statusColor(status),
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("👤 From: $name", style: FontStyles.body(context)),
                        Text("📍 Address: ${booking['fromAddress']}"),
                        Text("📅 Start: ${startDate.toLocal().toString().split(" ")[0]}"),
                        Text("⌛ Duration: ${booking['duration']}"),
                        Text("📝 Notes: ${booking['notes'] ?? 'None'}"),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(label: Text("Status: $status")),
                            if (status == 'pending') ...[
                              ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('bookings')
                                      .doc(booking.id)
                                      .update({'status': 'in_progress'});
                                },
                                child: const Text('Accept'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () => _showRejectionDialog(booking.id),
                                child: const Text('Reject'),
                              ),
                            ],
                            if (status == 'in_progress') ...[
                              ElevatedButton.icon(
                                icon: const Icon(Icons.map),
                                label: const Text('Track Trip'),
                                onPressed: () => _trackUser(booking['fromUserId']),
                              ),
                              Center(
                                child: CustomElevatedButton(
                                  icon: Icons.check_circle_outline,
                                  label: 'Mark as Completed',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (DateTime.now().isBefore(endDate)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Cannot complete before ${endDate.toLocal().toString().split(" ")[0]}'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }
                                    _confirmComplete(booking);
                                  },
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showRejectionDialog(String bookingId) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFECEAFF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reason for Rejection',
                  style: FontStyles.heading(context, fontSize: 22, color: Colors.black87)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter reason...',
                  hintStyle: FontStyles.body(context, color: Colors.black45),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: FontStyles.body(context, color: Colors.deepPurple)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
                        'status': 'rejected',
                        'rejectionReason': controller.text.trim(),
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking rejected ❌')),
                      );
                    },
                    child: Text('Submit',
                        style: FontStyles.body(context, color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _confirmComplete(DocumentSnapshot booking) async {
    final bookingId = booking.id;
    final fromUserId = booking['fromUserId'];
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Confirm Completion',
      message: 'Are you sure you want to mark this booking as completed?',
      confirmText: 'Complete',
      confirmColor: Colors.green,
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
        'status': 'completed',
      });
      await showRatingDialog(
        context: context,
        userIdToRate: fromUserId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking marked as completed ✅')),
      );
    }
  }

  void _trackUser(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!doc.exists || !doc.data()!.containsKey('location')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No location available")));
      return;
    }

    final geo = doc['location'] as GeoPoint;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingMapScreen(userLocation: LatLng(geo.latitude, geo.longitude)),
      ),
    );
  }


  DateTime _calculateEndDate(DateTime startDate, String duration) {
    switch (duration.trim().toLowerCase()) {
      case 'week':
        return startDate.add(const Duration(days: 7));
      case 'month':
        return startDate.add(const Duration(days: 30));
      case '2 days':
        return startDate.add(const Duration(days: 2));
      case 'day':
      default:
        return startDate.add(const Duration(days: 1));
    }
  }


  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade100;
      case 'in_progress':
        return Colors.blue.shade100;
      case 'completed':
        return Colors.green.shade200;
      case 'rejected':
        return Colors.grey.shade300;
      default:
        return Colors.white;
    }
  }
}
