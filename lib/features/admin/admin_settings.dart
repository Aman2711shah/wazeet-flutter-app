import 'package:flutter/material.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ListTile(title: Text('System Settings'), subtitle: Text('Configure global toggles')),
        SwitchListTile(value: true, onChanged: null, title: Text('Maintenance mode')),
        ListTile(title: Text('Email provider'), subtitle: Text('Resend / SendGrid (configure in Edge Functions)')),
      ],
    );
  }
}
