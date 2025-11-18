import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/routes/app_router.dart';
import 'package:book_library_app/main/app.dart';
import 'package:book_library_app/main/app_env.dart';
import 'package:book_library_app/core/constants/app_language.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:hive/hive.dart';

void main() => mainCommon(AppEnvironment.prod);

Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  EnvInfo.initialize(environment);

  // ✅ Hive setup via HiveService
  final hiveService = HiveService();
  await hiveService.init();

  final bookBox = Hive.box<BookModel>('books');

  // ✅ Add sample book if box is empty
  if (bookBox.isEmpty) {
    await bookBox.add(BookModel(
      id: '1',
      title: 'Test Book',
      author: 'Sneha',
      description: 'A sample book for testing',
      coverUrl: 'https://via.placeholder.com/150',
      category: 'Testing',
    ));
    print('✅ Sample book added');
  }

  print('📦 Hive book count: ${bookBox.length}');

  // ✅ Load translations
  Map<String, Map<String, String>> translations = {};
  try {
    translations = await loadTranslations();
  } catch (e) {
    debugPrint('❌ Translation loading failed: $e');
  }

  // ✅ Inject dependencies
  await init(bookBox);

  // ✅ Launch app
  runApp(BookLibraryApp(
    languageConfig: translations,
    router: router,
  ));
}