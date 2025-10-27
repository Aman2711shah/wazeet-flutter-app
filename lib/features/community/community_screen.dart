import 'package:flutter/material.dart';

/// Community feed placeholder. In later parts: posts, comments, likes.
/// Backed by RLS-safe tables (`posts`, `comments`) in Supabase.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        Card(
          child: ListTile(
            title: Text('Welcome to the Wazeet community!'),
            subtitle: Text('Share wins, ask questions, and connect by industry.'),
          ),
        ),
        SizedBox(height: 10),
        Card(
          child: ListTile(
            title: Text('Pro tip: Mainland vs Freezone'),
            subtitle: Text('Consider your visa needs and activity types before deciding.'),
          ),
        ),
      ],
    );
  }
}
