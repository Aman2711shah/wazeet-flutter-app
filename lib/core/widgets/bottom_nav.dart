import 'package:flutter/material.dart';

/// Bottom nav scaffold we’ll use later in HomeShell (Part 2+).
class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.design_services), label: 'Services'),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Growth'),
        BottomNavigationBarItem(icon: Icon(Icons.groups_2_outlined), label: 'Community'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
      ],
    );
  }
}
