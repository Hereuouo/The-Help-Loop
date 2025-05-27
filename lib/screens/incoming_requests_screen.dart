import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thehelploop/screens/tracking_map_screen.dart';
import '../services/tracking_map_factory.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/rating_dialog.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'dart:math' as math;
import 'package:geocoding/geocoding.dart' as geo;

import '../web/tracking_map_stub.dart'
    if (dart.library.html) '../web/tracking_map_web_screen.dart';

class IncomingRequestsScreen extends StatefulWidget {
  const IncomingRequestsScreen({super.key});

  @override
  State<IncomingRequestsScreen> createState() => _IncomingRequestsScreenState();
}

class _IncomingRequestsScreenState extends State<IncomingRequestsScreen>
    with SingleTickerProviderStateMixin {
  final currentUser = FirebaseAuth.instance.currentUser;
  final List<String> _statuses = [
    'All',
    'pending',
    'in_progress',
    'completed',
    'rejected',
    'payment_pending'
  ];
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
              labelStyle: FontStyles.body(context,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              controller: _tabController,
              isScrollable: true,
              unselectedLabelColor: Colors.teal.shade800,
              indicatorColor: Colors.white,
              tabs: _statuses.map((status) {
                return Tab(
                  text: status == 'All' ? 'All' : _prettyStatus(status),
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _statuses.map((status) {
                  return _buildBookingList(
                      status == 'All' ? null : status.toLowerCase());
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
      case 'payment_pending':
        return 'Payment Pending';
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
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

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
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(booking['fromUserId'])
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const SizedBox();
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;
                final name = userData?['name'] ?? 'Unknown';
                final userSkills = userData?['skills'] ?? [];

                return Card(
                  color: _statusColor(status),
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("👤 From: $name",
                            style: FontStyles.body(context,
                                color: Colors.pinkAccent)),
                        Text("🔧 Requested: ${booking['requestedSkill']}",
                            style: FontStyles.body(context,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text("📍 Address: ${booking['fromAddress']}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        Text(
                            "📅 Start: ${startDate.toLocal().toString().split(" ")[0]}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        Text("⌛ Duration: ${booking['duration']}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        Text("📝 Notes: ${booking['notes'] ?? 'None'}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        if (booking['exchangeType'] == 'skill')
                          Text(
                              "🔄 Exchanged Skill: ${booking['exchangedSkill']}",
                              style: FontStyles.body(context,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                        if (booking['exchangeType'] == 'fee')
                          Text(
                              "💰 Fee: ${booking['feeAmount']?.toStringAsFixed(2) ?? '0.00'}",
                              style: FontStyles.body(context,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                                label: Text("Status: ${_prettyStatus(status)}",
                                    style: FontStyles.body(context,
                                        color: Colors.black))),
                            if (status == 'pending') ...[
                              ElevatedButton(
                                onPressed: () => _showAcceptanceOptionsDialog(
                                    booking, userSkills, name),
                                child: Text(
                                  'Accept',
                                  style: FontStyles.body(context,
                                      fontSize: 18,
                                      color: Colors.teal.shade900,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () =>
                                    _showRejectionDialog(booking.id),
                                child: Text('Reject',
                                    style: FontStyles.body(context,
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                            if (status == 'in_progress') ...[
                              ElevatedButton.icon(
                                icon: const Icon(Icons.map),
                                label: Text('Track Trip',
                                    style: FontStyles.body(context,
                                        color: Colors.black)),
                                onPressed: () =>
                                    _trackUser(booking['fromUserId']),
                              ),
                              Center(
                                child: CustomElevatedButton(
                                  icon: Icons.check_circle_outline,
                                  label: 'Mark as Completed',
                                  style: FontStyles.heading(context,
                                      fontSize: 16, color: Colors.white),
                                  onPressed: () {
                                    if (DateTime.now().isBefore(endDate)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Cannot complete before ${endDate.toLocal().toString().split(" ")[0]}'),
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

  void _showAcceptanceOptionsDialog(
      DocumentSnapshot booking, List<dynamic> userSkills, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Exchange Type',
            style: FontStyles.heading(context, color: Colors.teal.shade900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You can choose how you want to be compensated:',
                style: FontStyles.body(context, color: Colors.black87)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.deepPurple),
              title: Text('Exchange Skills',
                  style: FontStyles.body(context,
                      fontWeight: FontWeight.bold, color: Colors.teal)),
              subtitle: Text('Choose one of $userName\'s skills in exchange',
                  style: FontStyles.body(context,
                      fontSize: 14, color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                _showSkillSelectionDialog(booking, userSkills, userName);
              },
              tileColor: Colors.purple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.green),
              title: Text('Request Fee',
                  style: FontStyles.body(context,
                      fontWeight: FontWeight.bold, color: Colors.teal)),
              subtitle: Text('Set a fee for your service',
                  style: FontStyles.body(context,
                      fontSize: 14, color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                _showFeeRequestDialog(booking);
              },
              tileColor: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: FontStyles.body(context, color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSkillSelectionDialog(
      DocumentSnapshot booking, List<dynamic> userSkills, String userName) {
    String? selectedSkill;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select a Skill from $userName',
              style: FontStyles.heading(context, color: Colors.teal.shade900)),
          content: SizedBox(
            width: double.maxFinite,
            child: userSkills.isEmpty
                ? Center(
                    child: Text('$userName has no registered skills.',
                        style: FontStyles.body(context, color: Colors.red)))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose one skill you want in exchange:',
                          style:
                              FontStyles.body(context, color: Colors.black87)),
                      const SizedBox(height: 12),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: userSkills.length,
                          itemBuilder: (context, index) {
                            final skill = userSkills[index].toString();
                            return RadioListTile<String>(
                              title: Text(skill,
                                  style: FontStyles.body(context,
                                      color: Colors.black)),
                              value: skill,
                              groupValue: selectedSkill,
                              onChanged: (value) {
                                setState(() {
                                  selectedSkill = value;
                                });
                              },
                              activeColor: Colors.deepPurple,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: FontStyles.body(context, color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: selectedSkill == null
                  ? null
                  : () async {
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (loadingContext) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        await FirebaseFirestore.instance
                            .collection('bookings')
                            .doc(booking.id)
                            .update({
                          'status': 'in_progress',
                          'exchangeType': 'skill',
                          'exchangedSkill': selectedSkill,
                        });

                        await _createReverseBooking(booking, selectedSkill!);

                        Navigator.of(context).pop();

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Booking accepted with skill exchange: $selectedSkill\n'
                              'A reciprocal booking has been created.',
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
              ),
              child: Text('Confirm Exchange',
                  style: FontStyles.body(context, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createReverseBooking(
      DocumentSnapshot originalBooking, String requestedSkill) async {
    final fromUserId = originalBooking['fromUserId'];
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    final requesterDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fromUserId)
        .get();

    if (!requesterDoc.exists) {
      throw Exception('Requester not found');
    }

    final requesterData = requesterDoc.data() as Map<String, dynamic>;
    final requesterGeo = requesterData['location'] as GeoPoint?;
    if (requesterGeo == null) {
      throw Exception('Requester location not available');
    }

    final providerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!providerDoc.exists) {
      throw Exception('Provider not found');
    }

    final providerData = providerDoc.data() as Map<String, dynamic>;
    final providerGeo = providerData['location'] as GeoPoint?;
    if (providerGeo == null) {
      throw Exception('Provider location not available');
    }

    final distanceKm = _calculateDistance(
      providerGeo.latitude,
      providerGeo.longitude,
      requesterGeo.latitude,
      requesterGeo.longitude,
    );

    String providerAddress;
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        providerGeo.latitude,
        providerGeo.longitude,
      );
      providerAddress = [
        placemarks.first.street,
        placemarks.first.subAdministrativeArea,
        placemarks.first.administrativeArea
      ].where((e) => e != null && e.isNotEmpty).join(', ');
    } catch (_) {
      providerAddress = '${providerGeo.latitude},${providerGeo.longitude}';
    }

    final reverseBookingMap = {
      'fromUserId': currentUser.uid,
      'toUserId': fromUserId,
      'requestedSkill': requestedSkill,
      'startDate': originalBooking['startDate'],
      'duration': originalBooking['duration'] ?? 'Day',
      'notes': 'Skill exchange for booking ID: ${originalBooking.id}',
      'fromLocation': providerGeo,
      'fromAddress': providerAddress,
      'distanceKm': distanceKm,
      'status': 'in_progress',
      'timestamp': FieldValue.serverTimestamp(),
      'exchangeType': 'skill',
      'exchangedSkill': originalBooking['requestedSkill'],
      'relatedBookingId': originalBooking.id,
    };

    await FirebaseFirestore.instance
        .collection('bookings')
        .add(reverseBookingMap);
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  void _showFeeRequestDialog(DocumentSnapshot booking) {
    final feeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Fee',
            style: FontStyles.heading(context, color: Colors.teal.shade900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the amount you want for your service:',
                style: FontStyles.body(context, color: Colors.black87)),
            const SizedBox(height: 16),
            TextField(
              controller: feeController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: FontStyles.body(context, color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              final feeText = feeController.text.trim();
              if (feeText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }

              double? fee = double.tryParse(feeText);
              if (fee == null || fee <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }

              await FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(booking.id)
                  .update({
                'status': 'payment_pending',
                'exchangeType': 'fee',
                'feeAmount': fee,
                'paymentStatus': 'pending',
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fee request of $fee sent to requester'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('Send Fee Request',
                style: FontStyles.body(context, color: Colors.white)),
          ),
        ],
      ),
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
                  style: FontStyles.heading(context,
                      fontSize: 22, color: Colors.black87)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter reason...',
                  hintStyle: FontStyles.body(context, color: Colors.black45),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style:
                            FontStyles.body(context, color: Colors.deepPurple)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .doc(bookingId)
                          .update({
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
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
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
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!doc.exists || !doc.data()!.containsKey('location')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No location available")));
      return;
    }

    final geo = doc['location'] as GeoPoint;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingMapFactory.create(
          userLocation: LatLng(geo.latitude, geo.longitude),
        ),
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
      case 'payment_pending':
        return Colors.yellow.shade100;
      default:
        return Colors.white;
    }
  }
}
