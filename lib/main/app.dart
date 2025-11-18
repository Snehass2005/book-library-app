import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:book_library_app/core/constants/app_language.dart';
import 'package:go_router/go_router.dart';

class BookLibraryApp extends StatelessWidget {
  final GoRouter router;
  final Map<String, Map<String, String>> languageConfig;

  const BookLibraryApp({
    super.key,
    required this.languageConfig,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadTranslations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Book Library',
          locale: const Locale('en'),
          supportedLocales: const [Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router, // ✅ uses the injected router with navigatorKey
        );
      },
    );
  }
}