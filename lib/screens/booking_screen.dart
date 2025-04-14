import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Book a Skill',
              style: FontStyles.heading(context, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Booking logic here
              },
              child: Text(
                'Confirm Booking',
                style: FontStyles.body(context, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
