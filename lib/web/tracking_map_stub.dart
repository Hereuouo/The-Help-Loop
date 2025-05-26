
import 'package:flutter/material.dart';

import '../models/tracking_map_interface.dart';

/// This is a stub implementation that's only used for the conditional import
/// in non-web platforms. It won't actually be instantiated.
class TrackingMapWebScreen extends TrackingMapInterface {
  const TrackingMapWebScreen({super.key, required super.userLocation});

  @override
  State createState() => throw UnsupportedError(
      'TrackingMapWebScreen is only available on web platforms');
}
