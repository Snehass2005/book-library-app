class Configuration {
  static const bool isDebug = true;
  static const String appVersion = "1.0.0";

  static String get environment => isDebug ? "Development" : "Production";
}
