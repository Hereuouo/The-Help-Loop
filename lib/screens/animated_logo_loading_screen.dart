import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import 'welcome_screen.dart';

class AnimatedLogoLoadingScreen extends StatefulWidget {
  const AnimatedLogoLoadingScreen({super.key});

  @override
  State<AnimatedLogoLoadingScreen> createState() => _AnimatedLogoLoadingScreenState();
}

class _AnimatedLogoLoadingScreenState extends State<AnimatedLogoLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );


    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            'lib/assets/images/BigLettersLogo.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}

