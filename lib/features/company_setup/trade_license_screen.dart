import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';

/// Thin, working placeholder. In Part 3 we’ll wire real steps + uploads.
class TradeLicenseScreen extends StatefulWidget {
  const TradeLicenseScreen({super.key});

  @override
  State<TradeLicenseScreen> createState() => _TradeLicenseScreenState();
}

class _TradeLicenseScreenState extends State<TradeLicenseScreen> {
  String _licenseType = 'Commercial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Trade License'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _licenseType,
            items: const [
              DropdownMenuItem(value: 'Commercial', child: Text('Commercial')),
              DropdownMenuItem(value: 'Professional', child: Text('Professional')),
              DropdownMenuItem(value: 'Industrial', child: Text('Industrial')),
            ],
            onChanged: (v) => setState(() => _licenseType = v ?? 'Commercial'),
            decoration: const InputDecoration(labelText: 'License Type'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Apply for $_licenseType license — flow in Part 3')),
              );
            },
            child: const Text('Start Application'),
          ),
        ],
      ),
    );
  }
}
