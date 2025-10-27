import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/supabase_client.dart';
import 'core/payments/stripe_service.dart';
import 'core/theme_controller.dart';
import 'core/locale_controller.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supa.init();

  const publishable = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  if (publishable.isNotEmpty) {
    await StripeService.init(publishable);
  }

  runApp(const ProviderScope(child: WazeetApp()));
}

class WazeetApp extends ConsumerWidget {
  const WazeetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePref = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    final light = ThemeData(
      colorSchemeSeed: Colors.indigo,
      brightness: Brightness.light,
      useMaterial3: true,
    );
    final dark = ThemeData(
      colorSchemeSeed: Colors.indigo,
      brightness: Brightness.dark,
      useMaterial3: true,
    );

    return MaterialApp.router(
      title: 'Wazeet',
      theme: light,
      darkTheme: dark,
      themeMode: switch (themePref) {
        ThemeModePref.light => ThemeMode.light,
        ThemeModePref.dark => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      routerConfig: useRouter(ref),
      // i18n
      locale: locale, // null => follow system
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supported) {
        if (locale != null) return locale;
        if (deviceLocale == null) return const Locale('en');
        for (final s in supported) {
          if (s.languageCode == deviceLocale.languageCode) return s;
        }
        return const Locale('en');
      },
    );
  }
}
