import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final double paddingV;
  final double paddingH;
  final double elevation;

  const CustomElevatedButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF00695C),
    this.iconColor = Colors.amberAccent,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.borderRadius = 30,
    this.paddingV = 14,
    this.paddingH = 28,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor),
      label: Text(
        label,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
