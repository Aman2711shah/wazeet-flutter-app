import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class QuickAction {
  final IconData icon;
  final String label;
  final String route;
  const QuickAction(this.icon, this.label, this.route);
}

/// Grid of prominent shortcuts on the landing dashboard.
/// Mirrors your web app’s QuickActions: Company Setup, Trade License, Growth.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  static const _actions = <QuickAction>[
    QuickAction(Icons.business, 'Company Setup', '/company-setup'),
    QuickAction(Icons.assignment, 'Trade License', '/trade-license'),
    QuickAction(Icons.trending_up, 'Growth', '/growth'),
    QuickAction(Icons.upload, 'Upload Documents', '/docs/upload'),
    QuickAction(Icons.people, 'Manage Users', '/users/manage'),
    QuickAction(Icons.settings, 'Settings', '/settings'),
    QuickAction(Icons.track_changes, 'Track Application', '/track-application'),
    QuickAction(Icons.support_agent, 'Support', '/support'),
    QuickAction(Icons.help, 'Help', '/help'),
    QuickAction(Icons.feedback, 'Feedback', '/feedback'),
    QuickAction(Icons.info, 'About', '/about'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: _actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, i) {
            final a = _actions[i];
            return Card(
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go(a.route),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a.icon, size: 30),
                      const SizedBox(height: 10),
                      Text(a.label, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
