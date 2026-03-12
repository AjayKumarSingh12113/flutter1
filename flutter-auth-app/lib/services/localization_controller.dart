import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  final List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('hi'),
    Locale('fr'),
    Locale('zh'),
  ];

  LocalizationController() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      return;
    }
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> setLocaleByCode(String languageCode) async {
    final locale = Locale(languageCode);
    await setLocale(locale);
  }

  String getLanguageName(String languageCode) {
    const languageNames = {
      'en': 'English',
      'hi': 'हिंदी',
      'fr': 'Français',
      'zh': '中文',
    };
    return languageNames[languageCode] ?? 'English';
  }

  List<String> getSupportedLanguageCodes() {
    return supportedLocales.map((locale) => locale.languageCode).toList();
  }
}
