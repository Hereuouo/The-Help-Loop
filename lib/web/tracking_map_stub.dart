
import 'package:flutter/material.dart';

import '../models/tracking_map_interface.dart';


class TrackingMapWebScreen extends TrackingMapInterface {
  const TrackingMapWebScreen({super.key, required super.userLocation});

  @override
  State createState() => throw UnsupportedError(
      'TrackingMapWebScreen is only available on web platforms');
}
