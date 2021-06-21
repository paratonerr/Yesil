import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations with ChangeNotifier {
  static AppLocalizations _instance;
  Locale _locale;
  Map<String, String> _strings = const {};

  AppLocalizations(this._locale);

  static String getString(String key) {

    return _instance?._strings[key] ?? "";
   }

  static Future<void> updateLocale(Locale locale) async {
    if (_instance == null) _instance = AppLocalizations(locale);
    _instance._locale = locale;
    await _instance.loadStrings();
  }

  Future<void> loadStrings() async {
    final String jsonString = await rootBundle.loadString(
      "langs/${_locale.languageCode}.json",
    );
    _strings = Map.from(jsonDecode(jsonString));
  }
}