import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/setup_repo.dart';

class CompanyFormationScreen extends ConsumerStatefulWidget {
  const CompanyFormationScreen({super.key});

  @override
  ConsumerState<CompanyFormationScreen> createState() => _CompanyFormationScreenState();
}

class _CompanyFormationScreenState extends ConsumerState<CompanyFormationScreen> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final qp = GoRouterState.of(context).uri.queryParameters;
    final zoneType = qp['zone'] ?? 'Freezone';
    final licenseType = qp['lic'] ?? 'Commercial';
    final shareholders = int.tryParse(qp['share'] ?? '1') ?? 1;
    final activitiesCount = int.tryParse(qp['acts'] ?? '1') ?? 1;
    final activityIds = (qp['aIds'] ?? '').split(',').where((e) => e.isNotEmpty).toList();
    final subActivityIds = (qp['sIds'] ?? '').split(',').where((e) => e.isNotEmpty).toList();

    Future<void> submit() async {
      setState(() => _submitting = true);
      final res = await setupRepo().createApplicationDraft(
        zoneType: zoneType,
        licenseType: licenseType,
        activities: activitiesCount,
        shareholders: shareholders,
        activityIds: activityIds,
        subActivityIds: subActivityIds,
        // estimatedCost can be added later (from estimator)
      );
      res.match(
        ok: (id) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Draft created (id=$id).')),
          );
          if (mounted) context.go('/');
        },
        err: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
        },
      );
      if (mounted) setState(() => _submitting = false);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Formation Summary'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(title: const Text('Zone Type'), trailing: Text(zoneType)),
          ListTile(title: const Text('License Type'), trailing: Text(licenseType)),
          ListTile(title: const Text('Shareholders'), trailing: Text('$shareholders')),
          ListTile(title: const Text('Activities count'), trailing: Text('$activitiesCount')),
          ListTile(title: const Text('Activity IDs'), subtitle: Text(activityIds.isEmpty ? '—' : activityIds.join(', '))),
          ListTile(title: const Text('Sub-activity IDs'), subtitle: Text(subActivityIds.isEmpty ? '—' : subActivityIds.join(', '))),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _submitting ? null : submit,
            child: _submitting ? const CircularProgressIndicator() : const Text('Submit Draft'),
          ),
        ],
      ),
    );
  }
}
