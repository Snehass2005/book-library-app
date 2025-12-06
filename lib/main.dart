import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_language.dart';
import 'core/dependency_injection/injector.dart';
import 'main/app.dart';
import 'main/app_env.dart';

void main() => mainCommon(AppEnvironment.prod);

Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  EnvInfo.initialize(environment);

  // ✅ Load translations
  Map<String, Map<String, String>> translations = await loadTranslations();

  // ✅ Inject dependencies
  await init();

  // ✅ Initialize Hive via DI
  await injector<HiveService>().init();

  // ✅ Launch app
  runApp(MyApp(languageConfig: translations));
}