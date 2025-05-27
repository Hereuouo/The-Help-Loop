import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TrackingMapInterface extends StatefulWidget {
  final LatLng userLocation;

  const TrackingMapInterface({super.key, required this.userLocation});
}
