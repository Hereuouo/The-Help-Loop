@JS()
library;

import 'package:js/js.dart';

@JS('initWebDirections')
external void initWebDirections(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
    );
