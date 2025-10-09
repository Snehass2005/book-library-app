enum AppLanguage { english, tamil, hindi }

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return "en.json";
      case AppLanguage.tamil:
        return "ta";
      case AppLanguage.hindi:
        return "hi";
    }
  }

  String get label {
    switch (this) {
      case AppLanguage.english:
        return "English";
      case AppLanguage.tamil:
        return "தமிழ்";
      case AppLanguage.hindi:
        return "हिंदी";
    }
  }
}
