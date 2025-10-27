import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization.dart';
import 'core/theme.dart';
import 'router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WazeetApp extends ConsumerWidget {
  const WazeetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = useRouter(ref);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Wazeet',
      routerConfig: router,

      // Localization (en + ar)
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Light/dark themes
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
    );
  }
}
