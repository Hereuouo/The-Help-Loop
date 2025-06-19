import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:provider/provider.dart';
import 'package:the_help_loop_master/generated/l10n.dart';
import 'package:the_help_loop_master/providers/locale_provider.dart';
import 'package:the_help_loop_master/screens/booking_screen.dart';
import 'dart:math' as math;

import '../services/backfill_service.dart';
import '../widgets/confirm_dialog.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';
import 'incoming_requests_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

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
  bool _showFilters = false;
  String? _userName;
  GeoPoint? _myLocation;

  RangeValues _ageRange = const RangeValues(18, 65);
  String? _selectedGender;
  double _maxDistance = 50;
  bool _onlyWithLocation = false;

  List<Map<String, dynamic>> _allSearchResults = [];
  List<Map<String, dynamic>> _exchangeMatches = [];
  List<Map<String, dynamic>> _paidMatches = [];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchMyLocation();
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
        _userName = doc['name'] ?? S.of(context).unknown;
      });
    }
  }

  Future<void> _fetchMyLocation() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (doc.exists && doc.data()?['location'] != null) {
      setState(() {
        _myLocation = doc.data()?['location'] as GeoPoint;
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
                '${S.of(context).playServicesUnavailable} (status: $availability)')),
      );
    }
  }

  double _calculateDistance(GeoPoint point1, GeoPoint point2) {
    const double earthRadius = 6371;

    double lat1Rad = point1.latitude * (math.pi / 180);
    double lat2Rad = point2.latitude * (math.pi / 180);
    double deltaLatRad = (point2.latitude - point1.latitude) * (math.pi / 180);
    double deltaLngRad =
        (point2.longitude - point1.longitude) * (math.pi / 180);

    double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLngRad / 2) *
            math.sin(deltaLngRad / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  bool _passesFilters(Map<String, dynamic> user) {
    int? userAge = user['age'];
    if (userAge != null) {
      if (userAge < _ageRange.start || userAge > _ageRange.end) {
        return false;
      }
    }

    if (_selectedGender != null && _selectedGender!.isNotEmpty) {
      String? userGender = user['gender'];
      if (userGender != _selectedGender) {
        return false;
      }
    }

    if (_onlyWithLocation || _maxDistance < 50) {
      GeoPoint? userLocation = user['location'];
      if (userLocation == null) {
        return !_onlyWithLocation;
      }

      if (_myLocation != null) {
        double distance = _calculateDistance(_myLocation!, userLocation);
        if (distance > _maxDistance) {
          return false;
        }

        user['distance'] = distance;
      }
    }

    return true;
  }

  void _applyFiltersToResults() {
    if (_allSearchResults.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final List<Map<String, dynamic>> filteredUsers = _allSearchResults
        .where((user) => user['id'] != currentUser.uid && _passesFilters(user))
        .toList();

    if (_myLocation != null) {
      filteredUsers.sort((a, b) {
        double distanceA = a['distance'] ?? double.infinity;
        double distanceB = b['distance'] ?? double.infinity;
        return distanceA.compareTo(distanceB);
      });
    }

    final List<Map<String, dynamic>> exchange = [];
    final List<Map<String, dynamic>> paid = [];

    for (final user in filteredUsers) {
      final theirHistory =
          List<String>.from(user['searchHistory'] ?? const <String>[]);
      bool mutual = false;

      if (user['mySkills'] != null) {
        final mySkills = List<String>.from(user['mySkills']);
        for (final historyItem in theirHistory) {
          for (final mySkill in mySkills) {
            if (_isSimpleMatch(historyItem, mySkill)) {
              mutual = true;
              break;
            }
          }
          if (mutual) break;
        }
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
    });
  }

  Future<void> _searchSkills() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).mustLoginFirst)),
      );
      return;
    }

    final query = _searchController.text.trim();
    if (query.length < 2) {
      setState(() {
        _hasSearched = true;
        _allSearchResults.clear();
        _exchangeMatches.clear();
        _paidMatches.clear();
      });
      return;
    }

    if (!RegExp(r'^[\p{L}\p{N}\s\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+$',
            unicode: true)
        .hasMatch(query)) {
      setState(() {
        _hasSearched = true;
        _allSearchResults.clear();
        _exchangeMatches.clear();
        _paidMatches.clear();
      });
      return;
    }

    setState(() {
      _hasSearched = true;
      _isLoading = true;
      _allSearchResults.clear();
      _exchangeMatches.clear();
      _paidMatches.clear();
    });

    try {
      List<String> vectorSearchIds = [];
      List<Map<String, dynamic>> searchResults = [];

      try {
        final callable = FirebaseFunctions.instance
            .httpsCallable('ext-firestore-vector-search-queryCallable');

        final callResult = await callable.call({
          'query': query,
          'collection': 'users',
          'input_field': 'input',
          'embedding_field': 'embedding',
          'limit': 15,
        });

        vectorSearchIds = List<String>.from(callResult.data['ids'] ?? []);
        print('Vector search found IDs: $vectorSearchIds');
      } catch (vectorError) {
        print(
            'Vector search failed, proceeding with fallback. Error: $vectorError');
      }

      if (vectorSearchIds.isNotEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: vectorSearchIds)
            .get();

        final Map<String, Map<String, dynamic>> usersMap = {
          for (var doc in snapshot.docs) doc.id: doc.data()..['id'] = doc.id
        };

        searchResults = vectorSearchIds
            .where(usersMap.containsKey)
            .map((id) => usersMap[id]!)
            .toList();
      } else {
        print('Executing simple text search fallback...');
        final allUsersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .limit(200)
            .get();

        final normalizedQuery = _normalizeText(query);
        for (final doc in allUsersSnapshot.docs) {
          final user = doc.data()..['id'] = doc.id;
          final theirSkills = List<String>.from(user['skills'] ?? []);
          for (final skill in theirSkills) {
            if (_isSimpleMatch(normalizedQuery, skill)) {
              searchResults.add(user);
              break;
            }
          }
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'searchHistory': FieldValue.arrayUnion([query])
      });

      final mySkillsDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final mySkills = List<String>.from(mySkillsDoc.data()?['skills'] ?? []);

      for (final user in searchResults) {
        user['mySkills'] = mySkills;
      }

      setState(() {
        _allSearchResults = searchResults;
        _isLoading = false;
      });

      _applyFiltersToResults();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${S.of(context).searchFailed}: $e')));
      }
    }
  }

  bool _isSimpleMatch(String searchTerm, String skill) {
    final normalizedSearch = _normalizeText(searchTerm);
    final normalizedSkill = _normalizeText(skill);

    if (normalizedSkill.contains(normalizedSearch) ||
        normalizedSearch.contains(normalizedSkill)) {
      return true;
    }

    final searchRoot = _getApproximateRoot(normalizedSearch);
    final skillRoot = _getApproximateRoot(normalizedSkill);

    if (searchRoot.isNotEmpty && skillRoot.isNotEmpty) {
      if (skillRoot.contains(searchRoot) || searchRoot.contains(skillRoot)) {
        return true;
      }
    }

    return false;
  }

  String _getApproximateRoot(String text) {
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      return text;
    }

    const suffixes = ['ing', 'er', 's', 'es', 'ed', 'or', 'tion'];
    var words = text.split(' ');
    var rootWords = <String>[];

    for (var word in words) {
      if (word.length < 5) {
        rootWords.add(word);
        continue;
      }

      String bestMatch = word;
      for (var suffix in suffixes) {
        if (word.endsWith(suffix)) {
          bestMatch = word.substring(0, word.length - suffix.length);
          break;
        }
      }
      rootWords.add(bestMatch);
    }

    return rootWords.join(' ');
  }

  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[\u064B-\u0652\u0670\u0640]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLanguage = localeProvider.locale.languageCode;

    return BaseScaffold(
      appBar: AppBar(
        title: Text(S.of(context).home,
            style:
                FontStyles.heading(context, fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list : Icons.filter_list_off,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
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
              if (_showFilters) _buildFiltersPanel(),
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
                hintText: S.of(context).searchSkills,
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

  Widget _buildFiltersPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).filters,
            style:
                FontStyles.heading(context, fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            '${S.of(context).ageRangeLabel}: ${_ageRange.start.round()} - ${_ageRange.end.round()} ${S.of(context).years}',
            style: const TextStyle(color: Colors.white70),
          ),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 65,
            divisions: 47,
            activeColor: Colors.white,
            inactiveColor: Colors.white30,
            onChanged: (values) {
              setState(() => _ageRange = values);

              _applyFiltersToResults();
            },
          ),
          Row(
            children: [
              Text(S.of(context).genderLabel,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedGender,
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  hint: Text(S.of(context).allGender,
                      style: const TextStyle(color: Colors.white70)),
                  items: [
                    DropdownMenuItem(
                        value: null, child: Text(S.of(context).allGender)),
                    DropdownMenuItem(
                        value: 'Male', child: Text(S.of(context).maleGender)),
                    DropdownMenuItem(
                        value: 'Female',
                        child: Text(S.of(context).femaleGender)),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedGender = value);

                    _applyFiltersToResults();
                  },
                ),
              ),
            ],
          ),
          if (_myLocation != null) ...[
            Text(
              '${S.of(context).maxDistanceLabel}: ${_maxDistance.round()} ${S.of(context).kilometers}',
              style: const TextStyle(color: Colors.white70),
            ),
            Slider(
              value: _maxDistance,
              min: 1,
              max: 100,
              divisions: 99,
              activeColor: Colors.white,
              inactiveColor: Colors.white30,
              onChanged: (value) {
                setState(() => _maxDistance = value);

                _applyFiltersToResults();
              },
            ),
          ],
          CheckboxListTile(
            title: Text(S.of(context).onlyWithLocation,
                style: const TextStyle(color: Colors.white70)),
            value: _onlyWithLocation,
            activeColor: Colors.white,
            checkColor: Colors.black,
            onChanged: (value) {
              setState(() => _onlyWithLocation = value ?? false);

              _applyFiltersToResults();
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
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
                  S.of(context).welcomeMessage,
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
              S.of(context).noMatchingUsers,
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
          Text(S.of(context).skillExchangeAvailable,
              style: FontStyles.heading(context,
                  fontSize: 18, color: Colors.white)),
          const SizedBox(height: 8),
          ..._exchangeMatches.map(_buildEnhancedUserCard),
          const SizedBox(height: 16),
        ],
        if (_paidMatches.isNotEmpty) ...[
          Text(S.of(context).requiresSmallFee,
              style: FontStyles.heading(context,
                  fontSize: 18, color: Colors.white)),
          const SizedBox(height: 8),
          ..._paidMatches.map(_buildEnhancedUserCard),
        ],
      ],
    );
  }

  Widget _buildEnhancedUserCard(Map<String, dynamic> user) {
    final skills = List<String>.from(user['skills'] ?? []);
    final distance = user['distance'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.teal,
                  child: Text(
                    (user['name'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? S.of(context).unknown,
                        style: FontStyles.heading(context,
                            fontSize: 16, color: Colors.black),
                      ),
                      Row(
                        children: [
                          if (user['age'] != null) ...[
                            Icon(Icons.cake, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${user['age']} ${S.of(context).years}',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (user['gender'] != null) ...[
                            Icon(
                              user['gender'] == 'Male'
                                  ? Icons.male
                                  : Icons.female,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user['gender'] == 'Male'
                                  ? S.of(context).maleGender
                                  : S.of(context).femaleGender,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                      if (distance != null)
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${distance.toStringAsFixed(1)} ${S.of(context).kilometers}',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      '${user['trustScore'] ?? S.of(context).unavailable}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (skills.isNotEmpty) ...[
              Text(
                S.of(context).skillsLabel,
                style: FontStyles.body(context, color: Colors.grey[700]!),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: skills
                    .map((skill) => Chip(
                          label:
                              Text(skill, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.teal.withOpacity(0.1),
                          side: BorderSide(color: Colors.teal.withOpacity(0.3)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
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
                icon: const Icon(Icons.message),
                label: Text(S.of(context).contact),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                        _userName ?? S.of(context).loading,
                        style: FontStyles.heading(context,
                            fontSize: 20, color: Colors.teal),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                _buildMenuItem(Icons.account_circle, S.of(context).profile, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()));
                }, iconColor: Colors.deepPurple),
                _buildMenuItem(
                    Icons.support_agent, S.of(context).systemSupport, () {},
                    iconColor: Colors.indigo),
                _buildMenuItem(
                    Icons.description, S.of(context).termsOfApp, () {},
                    iconColor: Colors.blue),
                _buildMenuItem(Icons.settings, S.of(context).appSettings, () {},
                    iconColor: Colors.orange),
                const Divider(),
                _buildMenuItem(Icons.logout, S.of(context).logout, () async {
                  final confirmed = await showConfirmDialog(
                    context: context,
                    title: S.of(context).confirmLogout,
                    message: S.of(context).logoutConfirmMessage,
                    confirmText: S.of(context).logout,
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
