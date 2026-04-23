import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  String _language = 'EN';

  String get language => _language;

  bool get isArabic => _language == 'AR';

  void setLanguage(String language) {
    if (_language != language) {
      _language = language;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _language = _language == 'EN' ? 'AR' : 'EN';
    notifyListeners();
  }
}
