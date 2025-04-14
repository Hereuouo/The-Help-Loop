import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Tracked Tasks',
              style: FontStyles.heading(context, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Track your bookings, skills offered, and volunteer hours here.',
              style: FontStyles.body(context, color: Colors.white),
            ),
            const SizedBox(height: 32),

            // TODO: Replace this placeholder with a ListView or dynamic data from Firestore
            Expanded(
              child: Center(
                child: Text(
                  'No activity tracked yet.',
                  style: FontStyles.body(context, color: Colors.white70),
                ),
              ),
            ),

            // TODO: Later, add refresh button or filters here if needed
          ],
        ),
      ),
    );
  }
}

