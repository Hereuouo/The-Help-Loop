import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_help_loop_master/screens/tracking_map_screen.dart';
import 'package:the_help_loop_master/generated/l10n.dart';
import '../services/tracking_map_factory.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/rating_dialog.dart';
import 'base_scaffold.dart';
import 'chat_screen.dart';
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

  final Map<String, int> _unreadMessageCounts = {};

  @override
  void initState() {
    _tabController = TabController(length: _statuses.length, vsync: this);
    super.initState();
    _listenToUnreadMessages();
  }

  void _listenToUnreadMessages() {
    FirebaseFirestore.instance
        .collection('bookings')
        .where('toUserId', isEqualTo: currentUser!.uid)
        .snapshots()
        .listen((bookingsSnapshot) {
      for (var bookingDoc in bookingsSnapshot.docs) {
        _listenToBookingMessages(bookingDoc.id);
      }
    });
  }

  void _listenToBookingMessages(String bookingId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(bookingId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUser!.uid)
        .snapshots()
        .listen((messagesSnapshot) {
      int unreadCount = 0;
      for (var messageDoc in messagesSnapshot.docs) {
        final data = messageDoc.data();
        final readBy = List<String>.from(data['readBy'] ?? []);
        if (!readBy.contains(currentUser!.uid)) {
          unreadCount++;
        }
      }

      if (mounted) {
        setState(() {
          _unreadMessageCounts[bookingId] = unreadCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: S.of(context).incomingRequests,
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
                  text: status == 'All'
                      ? S.of(context).all
                      : _prettyStatus(status),
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
        return S.of(context).statusPending;
      case 'in_progress':
        return S.of(context).statusInProgress;
      case 'completed':
        return S.of(context).statusCompleted;
      case 'rejected':
        return S.of(context).statusRejected;
      case 'payment_pending':
        return S.of(context).statusPaymentPending;
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
          return Center(child: CircularProgressIndicator());
        }

        final bookings = snapshot.data!.docs.where((doc) {
          if (status == null) return true;
          return doc['status']?.toLowerCase() == status;
        }).toList();

        if (bookings.isEmpty) {
          return Center(child: Text(S.of(context).noIncomingRequests));
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
                final name = userData?['name'] ?? S.of(context).unknown;
                final userSkills = userData?['skills'] ?? [];

                return Card(
                  color: _statusColor(status),
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("👤 ${S.of(context).fromUser}: $name",
                            style: FontStyles.body(context,
                                color: Colors.pinkAccent)),
                        Text(
                            "🔧 ${S.of(context).requestedSkill}: ${booking['requestedSkill']}",
                            style: FontStyles.body(context,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(
                            "📍 ${S.of(context).address}: ${booking['fromAddress']}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        Text(
                            "📅 ${S.of(context).startDate}: ${startDate.toLocal().toString().split(" ")[0]}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        Text(
                            "⌛ ${S.of(context).duration}: ${booking['duration']}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        Text(
                            "📝 ${S.of(context).notes}: ${booking['notes'] ?? S.of(context).none}",
                            style:
                                FontStyles.body(context, color: Colors.black)),
                        if (booking['exchangeType'] == 'skill')
                          Text(
                              "🔄 ${S.of(context).exchangedSkill}: ${booking['exchangedSkill']}",
                              style: FontStyles.body(context,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                        if (booking['exchangeType'] == 'fee')
                          Text(
                              "💰 ${S.of(context).fee}: ${booking['feeAmount']?.toStringAsFixed(2) ?? '0.00'}",
                              style: FontStyles.body(context,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                                label: Text(
                                    "${S.of(context).status}: ${_prettyStatus(status)}",
                                    style: FontStyles.body(context,
                                        color: Colors.black))),
                            _buildChatIconWithBadge(
                                booking.id, booking['fromUserId']),
                            if (status == 'pending') ...[
                              ElevatedButton(
                                onPressed: () => _showAcceptanceOptionsDialog(
                                    booking, userSkills, name),
                                child: Text(
                                  S.of(context).accept,
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
                                child: Text(S.of(context).reject,
                                    style: FontStyles.body(context,
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                            if (status == 'in_progress') ...[
                              ElevatedButton.icon(
                                icon: const Icon(Icons.map),
                                label: Text(S.of(context).trackTrip,
                                    style: FontStyles.body(context,
                                        color: Colors.black)),
                                onPressed: () =>
                                    _trackUser(booking['fromUserId']),
                              ),
                              Center(
                                child: CustomElevatedButton(
                                  icon: Icons.check_circle_outline,
                                  label: S.of(context).markAsCompleted,
                                  style: FontStyles.heading(context,
                                      fontSize: 16, color: Colors.white),
                                  onPressed: () {
                                    if (DateTime.now().isBefore(endDate)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(S
                                              .of(context)
                                              .cannotCompleteBefore(endDate
                                                  .toLocal()
                                                  .toString()
                                                  .split(" ")[0])),
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

  Widget _buildChatIconWithBadge(String bookingId, String fromUserId) {
    final unreadCount = _unreadMessageCounts[bookingId] ?? 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(Icons.chat_bubble_outline, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  bookingId: bookingId,
                  toUserId:
                      fromUserId == currentUser!.uid ? fromUserId : fromUserId,
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: FontStyles.body(
                  context,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showAcceptanceOptionsDialog(
      DocumentSnapshot booking, List<dynamic> userSkills, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).chooseExchangeType,
            style: FontStyles.heading(context, color: Colors.teal.shade900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).chooseCompensationMessage,
                style: FontStyles.body(context, color: Colors.black87)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.deepPurple),
              title: Text(S.of(context).exchangeSkills,
                  style: FontStyles.body(context,
                      fontWeight: FontWeight.bold, color: Colors.teal)),
              subtitle: Text(S.of(context).chooseUserSkillsExchange(userName),
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
              title: Text(S.of(context).requestFee,
                  style: FontStyles.body(context,
                      fontWeight: FontWeight.bold, color: Colors.teal)),
              subtitle: Text(S.of(context).setFeeForService,
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
            child: Text(S.of(context).cancel,
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
          title: Text(S.of(context).selectSkillFromUser(userName),
              style: FontStyles.heading(context, color: Colors.teal.shade900)),
          content: SizedBox(
            width: double.maxFinite,
            child: userSkills.isEmpty
                ? Center(
                    child: Text(S.of(context).userHasNoSkills(userName),
                        style: FontStyles.body(context, color: Colors.red)))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).chooseSkillInExchange,
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
              child: Text(S.of(context).cancel,
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
                          builder: (loadingContext) => Center(
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
                              S.of(context).bookingAcceptedWithSkillExchange(
                                      selectedSkill!) +
                                  '\n' +
                                  S.of(context).reciprocalBookingCreated,
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
                            content: Text('${S.of(context).error}: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
              ),
              child: Text(S.of(context).confirmExchange,
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
      throw Exception(S.of(context).userNotLoggedIn);
    }

    final requesterDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fromUserId)
        .get();

    if (!requesterDoc.exists) {
      throw Exception(S.of(context).requesterNotFound);
    }

    final requesterData = requesterDoc.data() as Map<String, dynamic>;
    final requesterGeo = requesterData['location'] as GeoPoint?;
    if (requesterGeo == null) {
      throw Exception(S.of(context).requesterLocationUnavailable);
    }

    final providerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!providerDoc.exists) {
      throw Exception(S.of(context).providerNotFound);
    }

    final providerData = providerDoc.data() as Map<String, dynamic>;
    final providerGeo = providerData['location'] as GeoPoint?;
    if (providerGeo == null) {
      throw Exception(S.of(context).providerLocationUnavailable);
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
      'notes': S.of(context).skillExchangeForBooking(originalBooking.id),
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
        title: Text(S.of(context).requestFee,
            style: FontStyles.heading(context, color: Colors.teal.shade900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).enterAmountForService,
                style: FontStyles.body(context, color: Colors.black87)),
            const SizedBox(height: 16),
            TextField(
              controller: feeController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                hintText: S.of(context).enterAmount,
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
            child: Text(S.of(context).cancel,
                style: FontStyles.body(context, color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              final feeText = feeController.text.trim();
              if (feeText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).enterValidAmount)),
                );
                return;
              }

              double? fee = double.tryParse(feeText);
              if (fee == null || fee <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).enterValidAmount)),
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
                  content: Text(S.of(context).feeRequestSent(fee.toString())),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text(S.of(context).sendFeeRequest,
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
              Text(S.of(context).reasonForRejection,
                  style: FontStyles.heading(context,
                      fontSize: 22, color: Colors.black87)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: S.of(context).enterReason,
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
                    child: Text(S.of(context).cancel,
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
                        SnackBar(content: Text(S.of(context).bookingRejected)),
                      );
                    },
                    child: Text(S.of(context).submit,
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
      title: S.of(context).confirmCompletion,
      message: S.of(context).confirmCompletionMessage,
      confirmText: S.of(context).complete,
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
        SnackBar(content: Text(S.of(context).bookingMarkedCompleted)),
      );
    }
  }

  void _trackUser(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!doc.exists || !doc.data()!.containsKey('location')) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).noLocationAvailable)));
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
