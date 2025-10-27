import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import 'admin_dashboard.dart';
import 'admin_users.dart';
import 'admin_roles.dart';
import 'admin_packages.dart';
import 'admin_content.dart';
import 'admin_analytics.dart';
import 'admin_settings.dart';
import 'admin_logs.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static final _tabs = <_Tab>[
    const _Tab('Dashboard', Icons.dashboard_outlined, AdminDashboard()),
    const _Tab('Users', Icons.people_alt_outlined, AdminUsers()),
    const _Tab('Roles', Icons.verified_user_outlined, AdminRoles()),
    const _Tab('Packages', Icons.inventory_2_outlined, AdminPackages()),
    const _Tab('Content', Icons.article_outlined, AdminContent()),
    const _Tab('Analytics', Icons.analytics_outlined, AdminAnalytics()),
    const _Tab('Settings', Icons.settings_outlined, AdminSettings()),
    const _Tab('Logs', Icons.history, AdminLogs()),
  ];

  @override
  Widget build(BuildContext context) {
    final shell = LayoutBuilder(builder: (context, c) {
      final isWide = c.maxWidth >= 900;
      final nav = NavigationRail(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _tabs.map((t) => NavigationRailDestination(icon: Icon(t.icon), label: Text(t.label))).toList(),
        labelType: NavigationRailLabelType.all,
      );

      final body = Expanded(child: _tabs[_index].child);
      return isWide
          ? Row(children: [nav, const VerticalDivider(width: 1), body])
          : Scaffold(
              body: body,
              bottomNavigationBar: NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                destinations: _tabs.map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label)).toList(),
              ),
            );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Admin Panel'),
          ],
        ),
      ),
      body: shell,
    );
  }
}

class _Tab {
  final String label;
  final IconData icon;
  final Widget child;
  const _Tab(this.label, this.icon, this.child);
}
