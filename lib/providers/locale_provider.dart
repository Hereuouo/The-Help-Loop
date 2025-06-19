import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadPreferredLanguage();
  }

  Future<void> _loadPreferredLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString('preferredLanguage');

    if (langCode == null) return;

    final Locale savedLocale = Locale(langCode);
    if (supportedLocales.contains(savedLocale)) {
      _locale = savedLocale;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferredLanguage', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('preferredLanguage');
    _locale = const Locale('en');
    notifyListeners();
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];
}
