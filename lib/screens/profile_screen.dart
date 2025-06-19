import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../models/user.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_elevated_button.dart';
import '../generated/l10n.dart';
import 'AddSkillScreen.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import '../widgets/map_picker_dialog.dart';
import 'my_booking_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _user;
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _nameController = TextEditingController();
  String _address = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception("User document not found");

      setState(() {
        _user = AppUser.fromMap(user.uid, userDoc.data()!);
        _nameController.text = _user!.name;
        _address = _user!.address ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty || newName == _user?.name) return;

    try {
      final user = _auth.currentUser;
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'name': newName});
      setState(() {
        _user = AppUser(
          id: _user!.id,
          name: newName,
          email: _user!.email,
          age: _user!.age,
          gender: _user!.gender,
          address: _user!.address,
          location: _user!.location,
          skills: _user!.skills,
          willingToPay: _user!.willingToPay,
          trustScore: _user!.trustScore,
        );
      });
      _showSnackbar(S.of(context).nameUpdatedSuccessfully);
    } catch (e) {
      _showSnackbar(S.of(context).failedToUpdate(e.toString()), isError: true);
    }
  }

  Future<void> _updateLocation() async {
    final LatLng? picked = await showDialog(
      context: context,
      builder: (_) => const MapPickerDialog(),
    );

    if (picked == null) return;

    String address = '';
    try {
      final placemarks =
      await geo.placemarkFromCoordinates(picked.latitude, picked.longitude);
      address = [
        placemarks.first.street,
        placemarks.first.locality,
        placemarks.first.administrativeArea,
      ].where((e) => e != null && e.isNotEmpty).join(', ');
    } catch (_) {
      address = '${picked.latitude}, ${picked.longitude}';
    }

    try {
      final user = _auth.currentUser;
      await _firestore.collection('users').doc(user!.uid).update({
        'location': GeoPoint(picked.latitude, picked.longitude),
        'address': address,
      });
      setState(() {
        _user = AppUser(
          id: _user!.id,
          name: _user!.name,
          email: _user!.email,
          age: _user!.age,
          gender: _user!.gender,
          address: address,
          location: GeoPoint(picked.latitude, picked.longitude),
          skills: _user!.skills,
          willingToPay: _user!.willingToPay,
          trustScore: _user!.trustScore,
        );
        _address = address;
      });
      _showSnackbar(S.of(context).locationUpdated);
    } catch (e) {
      _showSnackbar(S.of(context).failedToUpdate(e.toString()), isError: true);
    }
  }

  Future<void> _deleteSkill(String skill) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: S.of(context).confirmDelete,
      message: S.of(context).confirmDeleteSkill(skill),
      confirmText: S.of(context).delete,
      confirmColor: Colors.redAccent,
    );

    if (confirmed != true) return;

    try {
      final user = _auth.currentUser;
      await _firestore.collection('users').doc(user!.uid).update({
        'skills': FieldValue.arrayRemove([skill])
      });

      setState(() {
        final updatedSkills = List<String>.from(_user!.skills)..remove(skill);
        _user = AppUser(
          id: _user!.id,
          name: _user!.name,
          email: _user!.email,
          age: _user!.age,
          gender: _user!.gender,
          address: _user!.address,
          location: _user!.location,
          skills: updatedSkills,
          willingToPay: _user!.willingToPay,
          trustScore: _user!.trustScore,
        );
      });
      _showSnackbar(S.of(context).skillDeleted(skill));
    } catch (e) {
      _showSnackbar(S.of(context).failedToUpdate(e.toString()), isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal.shade400, size: 20),
          const SizedBox(width: 8),
          Text('$label: ', style: FontStyles.body(context, color: Colors.black87)),
          Expanded(
            child: Text(value, style: FontStyles.body(context, color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: S.of(context).profile,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF09203F), Color(0xFF537895)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddSkillScreen())),
        child: const Icon(Icons.add),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.teal),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: S.of(context).name,
                                labelStyle: TextStyle(color: Colors.teal.shade700),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save, color: Colors.teal),
                            onPressed: _updateName,
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.email, S.of(context).email, _user!.email),
                      _buildInfoRow(Icons.cake, S.of(context).age, _user!.age?.toString() ?? S.of(context).notSelected),
                      _buildInfoRow(Icons.person_outline, S.of(context).gender, _user!.gender ?? S.of(context).notSelected),
                      _buildInfoRow(Icons.verified_user, S.of(context).trustScore, _user!.trustScore.toString()),
                      _buildInfoRow(Icons.attach_money, S.of(context).willingToPay, _user!.willingToPay ? S.of(context).yes : S.of(context).no),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Text('📍 ${S.of(context).location}: $_address')),
                          IconButton(
                            icon: const Icon(Icons.location_on, color: Colors.teal),
                            onPressed: _updateLocation,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(S.of(context).skills,
                  style: FontStyles.heading(context, fontSize: 20, color: Colors.white)),
              const SizedBox(height: 8),
              Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _user!.skills.isEmpty
                      ? Text(S.of(context).noSkillsAdded, style: FontStyles.body(context, color: Colors.black54))
                      : Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _user!.skills.map((skill) {
                      return Chip(
                        label: Text(skill,
                            style: FontStyles.body(context,
                                fontSize: 18, color: Colors.white)),
                        backgroundColor: Colors.teal.shade700,
                        deleteIcon: const Icon(Icons.close, color: Colors.white),
                        onDeleted: () => _deleteSkill(skill),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomElevatedButton(
                  icon: Icons.calendar_today_outlined,
                  label: S.of(context).manageMyBookings,
                  style: FontStyles.heading(context,
                      fontSize: 18, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}