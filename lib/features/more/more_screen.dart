import 'package:flutter/material.dart';

/// “More” = settings, language toggle, profile, legal.
/// We’ll hook real data and i18n toggles later.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('System theme controls appearance')),
              );
            },
            title: const Text('Dark Mode'),
            subtitle: const Text('Follows system by default'),
          ),
        ),
        const SizedBox(height: 10),
        const Card(
          child: ListTile(
            title: Text('Language'),
            subtitle: Text('English / العربية (comming soon)'),
            trailing: Icon(Icons.translate),
          ),
        ),
        const SizedBox(height: 10),
        const Card(
          child: ListTile(
            title: Text('Legal & Privacy'),
            subtitle: Text('Terms, Privacy Policy'),
            trailing: Icon(Icons.description_outlined),
          ),
        ),
      ],
    );
  }
}
