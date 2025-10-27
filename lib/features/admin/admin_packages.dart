import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../data/package_repo.dart';
import '../../models/package.dart';

class AdminPackages extends ConsumerStatefulWidget {
  const AdminPackages({super.key});

  @override
  ConsumerState<AdminPackages> createState() => _AdminPackagesState();
}

class _AdminPackagesState extends ConsumerState<AdminPackages> {
  final _search = TextEditingController();
  final _cat = TextEditingController();
  bool? _isActive;

  final _id = TextEditingController();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _category = TextEditingController();
  bool _active = true;

  Future<void> _save() async {
    final p = Package(
      id: _id.text.trim(),
      name: _name.text.trim(),
      description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
      price: _price.text.trim().isEmpty ? null : num.tryParse(_price.text.trim()),
      category: _category.text.trim().isEmpty ? null : _category.text.trim(),
      isActive: _active,
    );
    final res = await packageRepo().upsert(p);
    res.match(
      ok: (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved'))),
      err: (e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'))),
    );
    setState(() {}); // refresh list
  }

  Future<void> _delete(String id) async {
    final res = await packageRepo().delete(id);
    res.match(
      ok: (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted'))),
      err: (e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'))),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pkgs = ref.watch(packagesProvider((search: _search.text.trim().isEmpty ? null : _search.text.trim(), category: _cat.text.trim().isEmpty ? null : _cat.text.trim(), isActive: _isActive)));

    return Row(
      children: [
        // Left: search/filter + list
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        decoration: const InputDecoration(labelText: 'Search packages'),
                        onSubmitted: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _cat,
                        decoration: const InputDecoration(labelText: 'Category filter'),
                        onSubmitted: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<bool?>(
                      value: _isActive,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('All')),
                        DropdownMenuItem(value: true, child: Text('Active')),
                        DropdownMenuItem(value: false, child: Text('Inactive')),
                      ],
                      onChanged: (v) => setState(() => _isActive = v),
                    ),
                    IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.search)),
                  ],
                ),
              ),
              Expanded(
                child: pkgs.when(
                  data: (res) => res.match(
                    ok: (list) => ListView.separated(
                      padding: const EdgeInsets.all(12),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final p = list[i];
                        return Card(
                          child: ListTile(
                            title: Text(p.name),
                            subtitle: Text('${p.id} • ${p.category ?? '-'} • ${p.isActive ? 'Active' : 'Inactive'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit), onPressed: () {
                                  _id.text = p.id;
                                  _name.text = p.name;
                                  _desc.text = p.description ?? '';
                                  _price.text = p.price?.toString() ?? '';
                                  _category.text = p.category ?? '';
                                  _active = p.isActive;
                                  setState(() {});
                                }),
                                IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(p.id)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    err: (e, _) => Center(child: Text('Failed: $e')),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        // Right: editor
        Expanded(
          flex: 1,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text('Create / Edit Package', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(controller: _id, decoration: const InputDecoration(labelText: 'ID (slug)')),
              const SizedBox(height: 8),
              TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 8),
              TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 8),
              TextField(controller: _price, decoration: const InputDecoration(labelText: 'Price (AED)'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: _category, decoration: const InputDecoration(labelText: 'Category')),
              const SizedBox(height: 8),
              SwitchListTile(
                value: _active,
                onChanged: (v) => setState(() => _active = v),
                title: const Text('Active'),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ],
    );
  }
}
