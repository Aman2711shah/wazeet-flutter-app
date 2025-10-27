import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';

class TradeLicenseStepper extends StatefulWidget {
  const TradeLicenseStepper({super.key});
  @override
  State<TradeLicenseStepper> createState() => _TradeLicenseStepperState();
}

class _TradeLicenseStepperState extends State<TradeLicenseStepper> {
  int _current = 0;
  String _licenseType = 'Commercial';
  final _companyName = TextEditingController();
  final _ownerName = TextEditingController();

  @override
  void dispose() {
    _companyName.dispose();
    _ownerName.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < 2) setState(() => _current++);
  }

  void _prev() {
    if (_current > 0) setState(() => _current--);
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trade application submitted (wire to DB in Part 4).')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Trade License Application'),
          ],
        ),
      ),
      body: Stepper(
        currentStep: _current,
        onStepContinue: _current == 2 ? _submit : _next,
        onStepCancel: _prev,
        steps: [
          Step(
            title: const Text('License Type'),
            content: DropdownButtonFormField<String>(
              initialValue: _licenseType,
              items: const [
                DropdownMenuItem(value: 'Commercial', child: Text('Commercial')),
                DropdownMenuItem(value: 'Professional', child: Text('Professional')),
                DropdownMenuItem(value: 'Industrial', child: Text('Industrial')),
              ],
              onChanged: (v) => setState(() => _licenseType = v ?? 'Commercial'),
            ),
          ),
          Step(
            title: const Text('Company Details'),
            content: Column(
              children: [
                TextField(controller: _companyName, decoration: const InputDecoration(labelText: 'Proposed Company Name')),
                const SizedBox(height: 8),
                TextField(controller: _ownerName, decoration: const InputDecoration(labelText: 'Owner/Manager Name')),
              ],
            ),
          ),
          const Step(
            title: Text('Documents'),
            content: Text('Upload docs via Supabase Storage (implemented in Part 4).'),
          ),
        ],
      ),
    );
  }
}
