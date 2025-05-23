// font_styles.dart
import 'package:flutter/material.dart';

class FontStyles {
  /// Returns the correct heading font based on the system language.
  static String getHeadingFont(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    return languageCode == 'ar' ? 'GhaithExtraBold' : 'MigraExtraBold';
  }

  /// Returns the correct body font based on the system language.
  static String getBodyFont(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    return languageCode == 'ar' ? 'GhaithRegular' : 'MigraExtraLight';
  }

  /// Returns a TextStyle for headings with dynamic font.
  static TextStyle heading(BuildContext context, {
    double fontSize = 24,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontFamily: getHeadingFont(context),
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  /// Returns a TextStyle for body text with dynamic font.
  static TextStyle body(BuildContext context, {
    double fontSize = 16,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontFamily: getBodyFont(context),
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
