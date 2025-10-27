import 'package:flutter/material.dart';
import '../../core/widgets/quick_actions.dart';

/// Landing dashboard (after login) mirroring your web landing:
/// - Welcome header
/// - QuickActions (Company Setup, Trade License, Growth)
/// - Optional “sections” (cards/lists) to be expanded in later parts
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headline = theme.textTheme.headlineSmall;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome to Wazeet', style: headline),
          const SizedBox(height: 6),
          Text(
            'Your UAE business setup assistant. Start, apply, and grow — all in one place.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          const QuickActions(),
          const SizedBox(height: 12),
          // Placeholder “sections” (will be wired to live data in later parts)
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    title: const Text('Track Application'),
                    subtitle: const Text('See status of recent submissions'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Track Application — coming soon')),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: ListTile(
                    title: const Text('Upcoming Bookings'),
                    subtitle: const Text('Your growth sessions and meetings'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bookings — coming soon')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
