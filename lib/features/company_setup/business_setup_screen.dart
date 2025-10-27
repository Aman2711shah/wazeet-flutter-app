import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers.dart';
import '../../models/activity.dart';
import '../../models/sub_activity.dart';

class BusinessSetupScreen extends ConsumerStatefulWidget {
  const BusinessSetupScreen({super.key});
  @override
  ConsumerState<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends ConsumerState<BusinessSetupScreen> {
  String _zoneType = 'Freezone';  // Mainland/Freezone
  String _licenseType = 'Commercial';
  int _shareholders = 1;
  int _activitiesCount = 1;

  // Activities / Sub-activities state
  final _activitySearch = TextEditingController();
  final _subActivitySearch = TextEditingController();
  final Set<String> _selectedActivityIds = {};
  final Set<String> _selectedSubActivityIds = {};

  @override
  void dispose() {
    _activitySearch.dispose();
    _subActivitySearch.dispose();
    super.dispose();
  }

  void _toggleActivity(Activity a) {
    setState(() {
      if (_selectedActivityIds.contains(a.id)) {
        _selectedActivityIds.remove(a.id);
        // also drop sub-activities under this activity
        // We can't know them here; they'll be filtered on next build anyway.
      } else {
        _selectedActivityIds.add(a.id);
      }
      _activitiesCount = _selectedActivityIds.length.clamp(1, 10);
    });
  }

  void _toggleSubActivity(SubActivity s) {
    setState(() {
      if (_selectedSubActivityIds.contains(s.id)) {
        _selectedSubActivityIds.remove(s.id);
      } else {
        _selectedSubActivityIds.add(s.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activitiesRes = ref.watch(activitiesProvider((zoneType: _zoneType, search: _activitySearch.text.trim().isEmpty ? null : _activitySearch.text.trim())));
    final subActivitiesRes = ref.watch(subActivitiesProvider((activityIds: _selectedActivityIds.toList(), search: _subActivitySearch.text.trim().isEmpty ? null : _subActivitySearch.text.trim())));

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Company Setup'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Zone & License
          DropdownButtonFormField<String>(
            initialValue: _zoneType,
            items: const [
              DropdownMenuItem(value: 'Mainland', child: Text('Mainland')),
              DropdownMenuItem(value: 'Freezone', child: Text('Freezone')),
            ],
            onChanged: (v) => setState(() {
              _zoneType = v ?? 'Freezone';
              _selectedActivityIds.clear();
              _selectedSubActivityIds.clear();
            }),
            decoration: const InputDecoration(labelText: 'Zone Type'),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),

          // Activities picker (multi)
          Text('Select Activities', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          TextField(
            controller: _activitySearch,
            decoration: InputDecoration(
              labelText: 'Search activities',
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () => setState(() {})),
            ),
            onSubmitted: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          activitiesRes.when(
            data: (res) => res.match(
              ok: (list) {
                if (list.isEmpty) return const Text('No activities found.');
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: list.map((a) {
                    final selected = _selectedActivityIds.contains(a.id);
                    return FilterChip(
                      label: Text(a.name),
                      selected: selected,
                      onSelected: (_) => _toggleActivity(a),
                    );
                  }).toList(),
                );
              },
              err: (e, _) => Text('Failed to load activities: $e'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 16),

          // Sub-activities picker (multi; dependent)
          Text('Select Sub-activities (optional)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          TextField(
            controller: _subActivitySearch,
            decoration: InputDecoration(
              labelText: 'Search sub-activities',
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () => setState(() {})),
            ),
            onSubmitted: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          subActivitiesRes.when(
            data: (res) => res.match(
              ok: (list) {
                if (_selectedActivityIds.isEmpty) {
                  return const Text('Select at least one activity to view sub-activities.');
                }
                if (list.isEmpty) return const Text('No sub-activities found for selected activities.');
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: list.map((s) {
                    final selected = _selectedSubActivityIds.contains(s.id);
                    return FilterChip(
                      label: Text(s.name),
                      selected: selected,
                      onSelected: (_) => _toggleSubActivity(s),
                    );
                  }).toList(),
                );
              },
              err: (e, _) => Text('Failed to load sub-activities: $e'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),

          const SizedBox(height: 16),
          // Shareholders & count (count reflects selected activities)
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _shareholders,
                  items: List.generate(10, (i) => i + 1)
                      .map((v) => DropdownMenuItem(value: v, child: Text('$v shareholders')))
                      .toList(),
                  onChanged: (v) => setState(() => _shareholders = v ?? 1),
                  decoration: const InputDecoration(labelText: 'Shareholders'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Activities selected',
                    hintText: _activitiesCount.toString(),
                  ),
                  controller: TextEditingController(text: _activitiesCount.toString()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _selectedActivityIds.isEmpty
                ? null
                : () {
                    // Pass state forward via query params or (better) a state holder; here we use query for simplicity.
                    final aIds = _selectedActivityIds.join(',');
                    final sIds = _selectedSubActivityIds.join(',');
                    context.go('/company-formation?zone=$_zoneType&lic=$_licenseType&share=$_shareholders&acts=$_activitiesCount&aIds=$aIds&sIds=$sIds');
                  },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continue to Summary'),
          ),
        ],
      ),
    );
  }
}
