import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme_controller.dart';
import '../../core/locale_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Privacy'),
              Tab(text: 'Security'),
              Tab(text: 'Notifications'),
              Tab(text: 'Account'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const _PrivacyTab(),
            const _SecurityTab(),
            const _NotificationsTab(),
            _AccountTab(ref: ref),
          ],
        ),
      ),
    );
  }
}

class _PrivacyTab extends StatelessWidget {
  const _PrivacyTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        SwitchListTile(value: true, onChanged: null, title: Text('Show profile publicly')),
        ListTile(title: Text('Data export'), subtitle: Text('Request your data (coming soon)')),
      ],
    );
  }
}

class _SecurityTab extends StatelessWidget {
  const _SecurityTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ListTile(title: Text('Two-factor auth'), subtitle: Text('Manage 2FA (coming soon)')),
        ListTile(title: Text('Active sessions'), subtitle: Text('View & revoke sessions')),
      ],
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        SwitchListTile(value: true, onChanged: null, title: Text('Email notifications')),
        SwitchListTile(value: false, onChanged: null, title: Text('Push notifications')),
      ],
    );
  }
}

class _AccountTab extends StatelessWidget {
  final WidgetRef ref;
  const _AccountTab({required this.ref});

  @override
  Widget build(BuildContext context) {
    final themePref = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final themeCtrl = ref.read(themeControllerProvider.notifier);
    final localeCtrl = ref.read(localeControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const ListTile(title: Text('Preferences')),
        // Theme
        DropdownButtonFormField<ThemeModePref>(
          initialValue: themePref,
          decoration: const InputDecoration(labelText: 'Theme'),
          items: const [
            DropdownMenuItem(value: ThemeModePref.system, child: Text('System')),
            DropdownMenuItem(value: ThemeModePref.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeModePref.dark, child: Text('Dark')),
          ],
          onChanged: (v) => themeCtrl.set(v ?? ThemeModePref.system),
        ),
        const SizedBox(height: 12),
        // Language
        DropdownButtonFormField<String>(
          initialValue: locale?.languageCode ?? 'system',
          decoration: const InputDecoration(labelText: 'Language'),
          items: const [
            DropdownMenuItem(value: 'system', child: Text('System')),
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'ar', child: Text('العربية')),
          ],
          onChanged: (code) {
            switch (code) {
              case 'en':
                localeCtrl.setLocale(const Locale('en'));
                break;
              case 'ar':
                localeCtrl.setLocale(const Locale('ar'));
                break;
              default:
                localeCtrl.setLocale(null);
            }
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Arabic automatically switches the UI to right-to-left (RTL) layout.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
