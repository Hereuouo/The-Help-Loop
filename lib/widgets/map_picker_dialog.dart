import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/font_styles.dart';
import 'custom_elevated_button.dart';

class MapPickerDialog extends StatefulWidget {
  const MapPickerDialog({super.key});

  @override
  State<MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<MapPickerDialog> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _picked = const LatLng(24.7136, 46.6753);

  @override
  void initState() {
    super.initState();
    _goToMyLocation();
  }

  Future<void> _goToMyLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      _picked = LatLng(pos.latitude, pos.longitude);
      (await _controller.future)
          .animateCamera(CameraUpdate.newLatLng(_picked));
      setState(() {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFECEAFF),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pick Location',
              style: FontStyles.heading(context, fontSize: 22, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 350,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: _picked, zoom: 14),
                  onMapCreated: (controller) => _controller.complete(controller),
                  markers: {Marker(markerId: const MarkerId('p'), position: _picked)},
                  myLocationEnabled: true,
                  onTap: (latLng) => setState(() => _picked = latLng),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: FontStyles.body(context, color: Colors.deepPurple)),
                ),
                CustomElevatedButton(
                  label: 'Select',
                  icon: Icons.check_circle_outline,
                  onPressed: () => Navigator.pop(context, _picked),
                    style: FontStyles.heading(context,
                        fontSize: 16, color: Colors.white)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
