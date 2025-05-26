// lib/screens/tracking_map_factory.dart
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/tracking_map_interface.dart';
import '../screens/tracking_map_screen.dart';
import '../web/tracking_map_stub.dart'
if (dart.library.html) '../web/tracking_map_web_screen.dart';

class TrackingMapFactory {
  static TrackingMapInterface create({required LatLng userLocation}) {
    if (kIsWeb) {
      return TrackingMapWebScreen(userLocation: userLocation);
    } else {
      return TrackingMapWebScreen(userLocation: userLocation);
    }
  }
}
