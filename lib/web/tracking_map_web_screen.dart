import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thehelploop/screens/base_scaffold.dart';

import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

import '../models/tracking_map_interface.dart';
import 'js_directions_web.dart';

class TrackingMapWebScreen extends TrackingMapInterface {
  const TrackingMapWebScreen({super.key, required super.userLocation});

  @override
  State<TrackingMapWebScreen> createState() => _TrackingMapWebScreenState();
}

class _TrackingMapWebScreenState extends State<TrackingMapWebScreen> {
  LatLng? _destination;
  double _distanceInKm = 0.0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    // Register the HTML view for the map
    ui_web.platformViewRegistry.registerViewFactory(
      'map-canvas',
          (int viewId) => html.DivElement()
        ..id = 'map'
        ..style.width = '100%'
        ..style.height = '100%',
    );

    // Listen for distance updates from JavaScript
    html.window.onMessage.listen((event) {
      final data = event.data;
      if (data['type'] == 'distanceUpdate') {
        setState(() {
          _distanceInKm = data['distance'].toDouble();
          _errorMessage = '';
        });
      } else if (data['type'] == 'distanceError') {
        setState(() {
          _errorMessage = data['error'];
        });
      }
    });

    _loadDestinationAndDrawRoute();
  }

  Future<void> _loadDestinationAndDrawRoute() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (doc.exists && doc.data()!.containsKey('location')) {
        final geo = doc['location'] as GeoPoint;
        _destination = LatLng(geo.latitude, geo.longitude);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _getPolylinePoints();
        });
      } else {
        setState(() {
          _errorMessage = 'Destination location not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching location: $e';
      });
    }

    if (mounted) setState(() {});
  }

  Future<void> _getPolylinePoints() async {
    if (_destination == null) return;

    final origin = widget.userLocation;
    final destination = _destination!;

    await Future.delayed(const Duration(milliseconds: 100));
    initWebDirections(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final destination = _destination;

    return BaseScaffold(
      title: 'Track Distance',
      child: destination == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          const HtmlElementView(viewType: 'map-canvas'),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.9),
              child: _errorMessage.isNotEmpty
                  ? Text(
                _errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              )
                  : Text(
                'Distance: ${_distanceInKm.toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}