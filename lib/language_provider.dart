import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'language_code';

  Locale _currentLocale;

  LanguageProvider({Locale initialLocale = const Locale('en')})
    : _currentLocale = initialLocale;

  Locale get currentLocale => _currentLocale;

  bool get isPortuguese => _currentLocale.languageCode == 'pt';

  bool get isEnglish => _currentLocale.languageCode == 'en';

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);

    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    if (_currentLocale.languageCode == 'en') {
      await changeLanguage(const Locale('pt'));
    } else {
      await changeLanguage(const Locale('en'));
    }
  }
}
