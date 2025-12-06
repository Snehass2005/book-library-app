import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'package:book_library_app/core/constants/constants.dart';

class AppTranslations extends Translations {
  final Map<String, Map<String, String>> translations;

  AppTranslations(this.translations);

  @override
  Map<String, Map<String, String>> get keys => translations;
}

Future<Map<String, Map<String, String>>> loadTranslations() async {
  String enJson = await rootBundle.loadString(englishLanguage);

  Map<String, dynamic> enMap = json.decode(enJson);

  return {
    'en': Map<String, String>.from(enMap)
  };
}