import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfigsProvider with ChangeNotifier {
  bool isDark;
  String language;

  ConfigsProvider({this.isDark = false, this.language = "en"});

  set changeDarkMode(value) {
    isDark = value;
    notifyListeners();
  }

  void changeLanguage(
    Locale locale,
    BuildContext context,
  ) async {
    await context.setLocale(locale);
    language = locale.languageCode;
    notifyListeners();
  }

  String getLanguage() {
    return language;
  }

  void invertDarkMode() {
    isDark = !isDark;
    notifyListeners();
  }
}
