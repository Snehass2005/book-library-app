import 'dart:convert';
import 'package:book_library_app/core/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';


class AppTranslations extends Translations {
  final Map<String, Map<String, String>> translations;

  AppTranslations(this.translations);

  @override
  Map<String, Map<String, String>> get keys => translations;
}

Future<Map<String, Map<String, String>>> loadTranslations() async {
  try {
    final enJson = await rootBundle.loadString(englishLanguage );
    final enMap = json.decode(enJson) as Map<String, dynamic>;

    return {
      'en': Map<String, String>.from(enMap),
    };
  } catch (e) {
    print('❌ Error loading English translations: $e');
    return {
      'en': {},
    };
  }
}