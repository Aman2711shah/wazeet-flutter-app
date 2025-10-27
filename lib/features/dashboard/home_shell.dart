import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/logo.dart';
import '../../core/widgets/bottom_nav.dart';
import '../auth/profile_menu.dart';

/// The shell that hosts the main tabs (Home, Services, Growth, Community, More).
/// Uses GoRouter’s ShellRoute (configured in router.dart). We derive the
/// current index from location and sync BottomNavigationBar with routes.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});
  final Widget child;

  static final _tabs = [
    const _TabSpec('Home', Icons.home_outlined, '/'),
    const _TabSpec('Services', Icons.design_services, '/services'),
    const _TabSpec('Growth', Icons.trending_up, '/growth'),
    const _TabSpec('Community', Icons.groups_2_outlined, '/community'),
    const _TabSpec('More', Icons.more_horiz, '/more'),
  ];

  int _indexFromLocation(String loc) {
    if (loc.startsWith('/services')) return 1;
    if (loc.startsWith('/growth')) return 2;
    if (loc.startsWith('/community')) return 3;
    if (loc.startsWith('/more')) return 4;
    return 0; // default: home
    }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(GoRouterState.of(context).uri.toString());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WazeetLogo(size: 24),
            const SizedBox(width: 8),
            Text(_tabs[currentIndex].label),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: ProfileMenu(),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (i) => context.go(_tabs[i].route),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Will become Virtual Assistant entrypoint later.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Virtual Assistant coming soon')),
          );
        },
        icon: const Icon(Icons.smart_toy_outlined),
        label: const Text('Assistant'),
      ),
    );
  }
}

class _TabSpec {
  final String label;
  final IconData icon;
  final String route;
  const _TabSpec(this.label, this.icon, this.route);
}
