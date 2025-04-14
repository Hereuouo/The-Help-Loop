import 'package:flutter/material.dart';
import 'font_styles.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;

  const BaseScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, //transparency for background
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/BlueBackground.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Centered logo at the top
          Positioned(
            top: 16, // Distance from the top
            left: 0,
            right: 0, // Stretch across the width
            child: Center(
              child: Image.asset(
                'lib/assets/images/NoTextLogo.png',
                width: 50,
                height: 50,
              ),
            ),
          ),

          // Main content with custom font styling
          SafeArea(
            child: DefaultTextStyle(
              style: FontStyles.body(context, color: Colors.white),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
