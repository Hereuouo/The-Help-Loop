import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/directions.dart' as gmaps;
import 'package:thehelploop/screens/base_scaffold.dart';

class TrackingMapScreen extends StatefulWidget {
  final LatLng userLocation;

  const TrackingMapScreen({super.key, required this.userLocation});

  @override
  State<TrackingMapScreen> createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<TrackingMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _destination;
  List<LatLng> polylineCoordinates = [];
  double _distanceInKm = 0.0;
  String _errorMessage = '';
  final String googleAPIKey = 'AIzaSyBEyjqNOslGapprZoExNxDI3M6HyuTzjNg';

  @override
  void initState() {
    super.initState();
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
        await _getPolylinePoints();
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

    final directions = gmaps.GoogleMapsDirections(apiKey: googleAPIKey);
    final response = await directions.directionsWithLocation(
      gmaps.Location(lat: origin.latitude, lng: origin.longitude),
      gmaps.Location(lat: destination.latitude, lng: destination.longitude),
      travelMode: gmaps.TravelMode.driving,
    );

    if (response.isOkay && response.routes.isNotEmpty) {
      final encoded = response.routes.first.overviewPolyline.points;

      final decodedPoints = PolylinePoints().decodePolyline(encoded);
      polylineCoordinates =
          decodedPoints.map((e) => LatLng(e.latitude, e.longitude)).toList();

      final leg = response.routes.first.legs.first;
      final distanceInMeters = leg.distance.value;
      _distanceInKm = distanceInMeters / 1000;

      setState(() {
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage =
            'No route found: ${response.errorMessage ?? response.status}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final origin = widget.userLocation;
    final destination = _destination;

    return BaseScaffold(
      title: 'Track Distance',
      child: destination == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: origin, zoom: 13),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: {
                    Marker(
                      markerId: const MarkerId('origin'),
                      position: origin,
                      infoWindow: const InfoWindow(title: 'Sender'),
                    ),
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: destination,
                      infoWindow: const InfoWindow(title: 'You'),
                    ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      color: Colors.blue,
                      width: 5,
                      points: polylineCoordinates,
                    ),
                  },
                ),
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
