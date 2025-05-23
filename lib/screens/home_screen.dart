import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:thehelploop/screens/booking_screen.dart';

import '../services/backfill_service.dart';
import '../widgets/confirm_dialog.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'incoming_requests_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _fade = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..forward();
  late final Animation<double> _opacity =
      Tween<double>(begin: 0, end: 1).animate(_fade);

  bool isMenuOpen = false;
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _userName;

  List<Map<String, dynamic>> _exchangeMatches = [];
  List<Map<String, dynamic>> _paidMatches = [];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _runBackfillOnce();
    _checkPlayServices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fade.dispose();
    super.dispose();
  }

  Future<void> _fetchUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (doc.exists) {
      setState(() {
        _userName = doc['name'] ?? 'Unknown';
      });
    }
  }

  Future<void> _runBackfillOnce() async =>
      BackfillService().runBackfillForUsers();

  Future<void> _checkPlayServices() async {
    final availability = await GoogleApiAvailability.instance
        .checkGooglePlayServicesAvailability();
    if (availability != GooglePlayServicesAvailability.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Google Play Services غير متوفّر (status: $availability)')),
      );
    }
  }

  Future<void> _searchSkills() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
      );
      return;
    }

    final query = _searchController.text.trim();
    if (query.length < 2 ||
        !RegExp(r'^[\p{L}\p{N}\s]+$', unicode: true).hasMatch(query)) {
      setState(() {
        _hasSearched = true;
        _exchangeMatches.clear();
        _paidMatches.clear();
      });
      return;
    }

    setState(() {
      _hasSearched = true;
      _isLoading = true;
      _exchangeMatches.clear();
      _paidMatches.clear();
    });

    try {
      final callable = FirebaseFunctions.instance
          .httpsCallable('ext-firestore-vector-search-queryCallable');

      final callResult = await callable.call({
        'query': query,
        'limit': 20,
      });

      final List<String> ids = List<String>.from(callResult.data['ids'] ?? []);
      if (ids.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final fs = FirebaseFirestore.instance;
      final snapshot = await fs
          .collection('users')
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      final Map<String, Map<String, dynamic>> tmp = {
        for (var doc in snapshot.docs) doc.id: doc.data()..['id'] = doc.id
      };
      final List<Map<String, dynamic>> ordered =
          ids.where(tmp.containsKey).map((id) => tmp[id]!).toList();

      await fs.collection('users').doc(currentUser.uid).update({
        'searchHistory': FieldValue.arrayUnion([query])
      });

      final List<Map<String, dynamic>> filteredUsers = [];
      for (final user in ordered) {
        if (user['id'] == currentUser.uid) continue;

        final theirSkills =
            List<String>.from(user['skills'] ?? const <String>[]);
        bool isRelevant = false;

        for (final skill in theirSkills) {
          if (await _isSemanticallySimilar(query, skill, threshold: 0.7)) {
            isRelevant = true;
            break;
          }
        }

        if (isRelevant) {
          filteredUsers.add(user);
        }
      }

      final mySkills = List<String>.from(
          (await fs.collection('users').doc(currentUser.uid).get())
                  .data()?['skills'] ??
              []);

      final List<Map<String, dynamic>> exchange = [];
      final List<Map<String, dynamic>> paid = [];

      for (final user in filteredUsers) {
        final theirHistory =
            List<String>.from(user['searchHistory'] ?? const <String>[]);
        bool mutual = false;

        for (final h in theirHistory) {
          for (final s in mySkills) {
            if (await _isSemanticallySimilar(h, s, threshold: 0.7)) {
              mutual = true;
              break;
            }
          }
          if (mutual) break;
        }

        if (mutual) {
          exchange.add(user);
        } else if (user['willingToPay'] == true) {
          paid.add(user);
        }
      }

      setState(() {
        _exchangeMatches = exchange;
        _paidMatches = paid;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('فشل البحث: $e')));
      }
    }
  }

  Future<bool> _isSemanticallySimilar(String text1, String text2,
      {double threshold = 0.7}) async {
    try {
      final similarity = await _calculateSimilarity(text1, text2);
      return similarity >= threshold;
    } catch (e) {
      return text1.toLowerCase().contains(text2.toLowerCase()) ||
          text2.toLowerCase().contains(text1.toLowerCase());
    }
  }

  Future<double> _calculateSimilarity(String text1, String text2) async {
    final apiKey = 'AlzaSyD30YFEm9x2w99V5SPtFideT7Qjiy40VHM';
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent?key=$apiKey';

    final response1 = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': {
          'parts': [
            {'text': text1}
          ]
        },
      }),
    );

    if (response1.statusCode != 200) {
      throw Exception('Failed to get embedding for text1: ${response1.body}');
    }

    final data1 = jsonDecode(response1.body);
    final embedding1 = List<double>.from(data1['embedding']['values']);

    final response2 = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': {
          'parts': [
            {'text': text2}
          ]
        },
      }),
    );

    if (response2.statusCode != 200) {
      throw Exception('Failed to get embedding for text2: ${response2.body}');
    }

    final data2 = jsonDecode(response2.body);
    final embedding2 = List<double>.from(data2['embedding']['values']);

    return _cosineSimilarity(embedding1, embedding2);
  }

  double _cosineSimilarity(List<double> vector1, List<double> vector2) {
    if (vector1.length != vector2.length) {
      throw Exception('Vectors must have the same length');
    }

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < vector1.length; i++) {
      dotProduct += vector1[i] * vector2[i];
      norm1 += vector1[i] * vector1[i];
      norm2 += vector2[i] * vector2[i];
    }

    norm1 = math.sqrt(norm1);
    norm2 = math.sqrt(norm2);

    if (norm1 == 0 || norm2 == 0) {
      return 0.0;
    }

    return dotProduct / (norm1 * norm2);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: Text('Home',
            style:
                FontStyles.heading(context, fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .where('fromUserId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot1) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('toUserId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot2) {
                  final hasBookings =
                      (snapshot1.data?.docs.isNotEmpty ?? false) ||
                          (snapshot2.data?.docs.isNotEmpty ?? false);

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const IncomingRequestsScreen()),
                          );
                        },
                      ),
                      if (hasBookings)
                        const Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
        child: const Icon(Icons.more_vert),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(),
              Expanded(child: _buildResultsArea()),
            ],
          ),
          if (isMenuOpen) _buildSideMenuOverlay(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for skills…',
                hintStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              onSubmitted: (_) => _searchSkills(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _searchSkills,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _opacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search, size: 48, color: Colors.white70),
                const SizedBox(height: 12),
                Text(
                  'Welcome! Use the search bar above to look for a skill or service.\n\nYou can also check your incoming requests to offer your help if needed.',
                  style: FontStyles.body(context, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_exchangeMatches.isEmpty && _paidMatches.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 48, color: Colors.orangeAccent),
            const SizedBox(height: 12),
            Text(
              'No matching users found for this skill.\nPlease try a different search keyword.',
              style: FontStyles.body(context, color: Colors.orangeAccent),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (_exchangeMatches.isNotEmpty) ...[
          Text('Skill Exchange Available',
              style: FontStyles.heading(context,
                  fontSize: 18, color: Colors.white)),
          const SizedBox(height: 8),
          ..._exchangeMatches.map(_buildUserCard),
          const SizedBox(height: 16),
        ],
        if (_paidMatches.isNotEmpty) ...[
          Text('Requires Small Fee',
              style: FontStyles.heading(context,
                  fontSize: 18, color: Colors.white)),
          const SizedBox(height: 8),
          ..._paidMatches.map(_buildUserCard),
        ],
      ],
    );
  }

  Card _buildUserCard(Map<String, dynamic> user) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text(user['name'] ?? 'Unknown',
              style: FontStyles.body(context, color: Colors.black)),
          subtitle: Text('Trust Score: ${user['trustScore'] ?? 'unavailable'}',
              style: FontStyles.body(context, color: Colors.black54)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingScreen(
                  userId: user['id'],
                  requestedSkill: _searchController.text.trim(),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildSideMenuOverlay() => GestureDetector(
        onTap: () => setState(() => isMenuOpen = false),
        child: Container(
          color: Colors.black45,
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                )
              ],
            ),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _userName ?? 'Loading...',
                        style: FontStyles.heading(context,
                            fontSize: 20, color: Colors.teal),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                _buildMenuItem(Icons.account_circle, 'Profile', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()));
                }, iconColor: Colors.deepPurple),
                _buildMenuItem(Icons.support_agent, 'System Support', () {},
                    iconColor: Colors.indigo),
                _buildMenuItem(Icons.description, 'Terms of App', () {},
                    iconColor: Colors.blue),
                _buildMenuItem(Icons.settings, 'App Settings', () {},
                    iconColor: Colors.orange),
                const Divider(),
                _buildMenuItem(Icons.logout, 'Log Out', () async {
                  final confirmed = await showConfirmDialog(
                    context: context,
                    title: 'Confirm Logout',
                    message: 'Are you sure you want to log out?',
                    confirmText: 'Logout',
                    confirmColor: Colors.redAccent,
                  );
                  if (confirmed == true) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                }, iconColor: Colors.redAccent),
              ],
            ),
          ),
        ),
      );

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {Color iconColor = Colors.teal}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      hoverColor: Colors.teal.shade50,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}
