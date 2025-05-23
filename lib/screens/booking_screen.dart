import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../models/booking.dart';
import '../widgets/map_picker_dialog.dart';
import '../widgets/custom_elevated_button.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';

class BookingScreen extends StatelessWidget {
  final String userId;
  final String? requestedSkill;

  const BookingScreen({
    super.key,
    required this.userId,
    this.requestedSkill,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final data = snap.data!.data() as Map<String, dynamic>;
        final name = data['name'] ?? 'Unknown';
        final skills = data['skills'] ?? [];

        return BaseScaffold(
          title: 'Booking Skill Details',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: FontStyles.heading(context,
                        fontSize: 28, color: Colors.white)),
                const SizedBox(height: 16),
                if (requestedSkill != null) ...[
                  Text('Requested Skill:',
                      style: FontStyles.body(context, color: Colors.white70)),
                  Text(requestedSkill!,
                      style: FontStyles.heading(context,
                          fontSize: 20, color: Colors.amberAccent)),
                  const Divider(height: 32, color: Colors.white24),
                ],
                Text('All Skills:',
                    style: FontStyles.body(context, color: Colors.white70)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map<Widget>(
                        (s) => Chip(
                          label: Text(s.toString()),
                          backgroundColor: Colors.white,
                          labelStyle:
                              FontStyles.body(context, color: Colors.black),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 40),
                Center(
                  child: CustomElevatedButton(
                      icon: Icons.calendar_today_outlined,
                      label: 'Book Service',
                      onPressed: () => _showBookingDialog(
                            context: context,
                            toUserId: userId,
                            requestedSkill: requestedSkill ?? '',
                          ),
                      style: FontStyles.body(context,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBookingDialog({
    required BuildContext context,
    required String toUserId,
    required String requestedSkill,
  }) {
    DateTime? chosenDate;
    String duration = 'Day';
    LatLng? pickedLoc;
    String addressTxt = '';
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFECEAFF),
        title: Center(
            child: Text('Book Service',
                style: FontStyles.heading(context,
                    fontSize: 22, color: Colors.teal.shade900))),
        content: StatefulBuilder(
          builder: (ctx, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    chosenDate == null
                        ? 'Choose start date'
                        : '${chosenDate!.toLocal()}'.split(' ')[0],
                    style:
                        FontStyles.body(context, color: Colors.teal.shade900),
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: now,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => chosenDate = picked);
                  },
                ),
                DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      labelStyle: TextStyle(fontSize: 19),
                    ),
                    value: duration,
                    items: const [
                      DropdownMenuItem(value: 'Day', child: Text('Day')),
                      DropdownMenuItem(value: '2 Days', child: Text('2 Days')),
                      DropdownMenuItem(value: 'Week', child: Text('Week')),
                      DropdownMenuItem(value: 'Month', child: Text('Month')),
                    ],
                    onChanged: (v) => duration = v ?? 'Day',
                    style: FontStyles.heading(context,
                        fontSize: 16, color: Colors.teal.shade900)),
                ListTile(
                  title:
                      Text(pickedLoc == null ? 'Choose location' : addressTxt),
                  trailing: const Icon(Icons.location_on),
                  onTap: () async {
                    final LatLng? res = await showDialog(
                      context: ctx,
                      builder: (_) => const MapPickerDialog(),
                    );
                    if (res != null) {
                      pickedLoc = res;
                      try {
                        final placemarks = await geo.placemarkFromCoordinates(
                            res.latitude, res.longitude);
                        addressTxt = [
                          placemarks.first.street,
                          placemarks.first.subAdministrativeArea,
                          placemarks.first.administrativeArea
                        ].where((e) => e != null && e.isNotEmpty).join(', ');
                      } catch (_) {
                        addressTxt = '${res.latitude},${res.longitude}';
                      }
                      setState(() {});
                    }
                  },
                ),
                TextField(
                  controller: notesCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Notes (optional)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel',
                style: FontStyles.body(context, color: Colors.deepPurple)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            label: Text('Confirm',
                style: FontStyles.body(context, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              if (chosenDate == null || pickedLoc == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Complete all fields please',
                        style: FontStyles.body(context, color: Colors.white))));
                return;
              }
              await _createBooking(
                context: context,
                toUserId: toUserId,
                requestedSkill: requestedSkill,
                startDate: chosenDate!,
                duration: duration,
                notes: notesCtrl.text.trim(),
                fromLatLng: pickedLoc!,
                fromAddress: addressTxt,
              );
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createBooking({
    required BuildContext context,
    required String toUserId,
    required String requestedSkill,
    required DateTime startDate,
    required String duration,
    String? notes,
    required LatLng fromLatLng,
    required String fromAddress,
  }) async {
    final current = FirebaseAuth.instance.currentUser;
    if (current == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You must login first.',
              style: FontStyles.body(context, color: Colors.white))));
      return;
    }

    final providerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(toUserId)
        .get();
    final toGeo = providerDoc.data()?['location'];
    if (toGeo == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Provider location unavailable.',
              style: FontStyles.body(context, color: Colors.white))));
      return;
    }

    final LatLng toLatLng = LatLng(toGeo.latitude, toGeo.longitude);
    final distanceKm = _haversineKm(
      fromLatLng.latitude,
      fromLatLng.longitude,
      toLatLng.latitude,
      toLatLng.longitude,
    );

    final booking = BookingRequest(
      fromUserId: current.uid,
      toUserId: toUserId,
      requestedSkill: requestedSkill,
      startDate: startDate,
      duration: duration,
      notes: notes,
      fromLocation: GeoPoint(fromLatLng.latitude, fromLatLng.longitude),
      fromAddress: fromAddress,
      distanceKm: distanceKm,
    );

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .add(booking.toMap());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Booking sent ✅',
              style: FontStyles.body(context, color: Colors.white))));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * math.pi / 180;
}
