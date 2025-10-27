import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import '../../core/supabase_client.dart';
import '../../core/payments/stripe_service.dart';

class GrowthBookingScreen extends StatefulWidget {
  final String? serviceId; // optional; pass it from list when available
  const GrowthBookingScreen({super.key, this.serviceId});

  @override
  State<GrowthBookingScreen> createState() => _GrowthBookingScreenState();
}

class _GrowthBookingScreenState extends State<GrowthBookingScreen> {
  DateTime? _date;
  TimeOfDay? _time;
  bool _busy = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context, firstDate: now, lastDate: now.add(const Duration(days: 90)), initialDate: now);
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) setState(() => _time = t);
  }

  Future<void> _bookAndPay() async {
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pick date and time')));
      return;
    }
    setState(() => _busy = true);
    try {
      final dt = DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
      final uid = Supa.client.auth.currentUser!.id;

      // Example: AED 150 booking fee
      await StripeService.payAED(amountMinor: 15000, description: 'Growth Booking');

      // Record booking
      await Supa.client.from('growth_bookings').insert({
        'user_id': uid,
        'service_id': widget.serviceId,
        'datetime': dt.toUtc().toIso8601String(),
      }).select('id').single();

      // Record payment
      await Supa.client.from('payments').insert({
        'user_id': uid,
        'amount_minor': 15000,
        'currency': 'AED',
        'status': 'succeeded',
        'service_id': widget.serviceId,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booked & paid.')));
        Navigator.of(context).pop();
      }
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _date == null ? 'Pick date' : '${_date!.year}-${_date!.month}-${_date!.day}';
    final timeText = _time == null ? 'Pick time' : _time!.format(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Book Growth Session'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Date'),
              subtitle: Text(dateText),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: const Text('Time'),
              subtitle: Text(timeText),
              trailing: const Icon(Icons.schedule),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _busy ? null : _bookAndPay,
                child: _busy ? const CircularProgressIndicator() : const Text('Pay & Book'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
