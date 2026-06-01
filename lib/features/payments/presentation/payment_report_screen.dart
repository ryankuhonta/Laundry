import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/exit_confirmation_scope.dart';
import '../../customers/application/laundry_repository_provider.dart';
import '../../staff_auth/application/staff_auth_provider.dart';
import '../application/payment_report_providers.dart';
import '../domain/payment_report.dart';

class PaymentReportScreen extends ConsumerWidget {
  const PaymentReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(paymentReportProvider);
    final range = ref.watch(paymentReportRangeProvider);

    return ExitConfirmationScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payments & Sales'),
          actions: [
            TextButton.icon(
              onPressed: () => context.go('/dashboard'),
              icon: const Icon(Icons.dashboard_outlined),
              label: const Text('Dashboard'),
            ),
            TextButton.icon(
              onPressed: () {
                ref.read(staffSessionUnlockedProvider.notifier).state = false;
                context.go('/kiosk');
              },
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('Kiosk'),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: report.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Text('Could not load payment report: $error'),
              data: (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DateRangeBar(range: range),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _MetricTile(
                        label: 'Sales',
                        value: _money(data.salesTotal),
                        icon: Icons.payments_outlined,
                      ),
                      _MetricTile(
                        label: 'Paid',
                        value: data.paidVisitCount.toString(),
                        icon: Icons.check_circle_outline,
                      ),
                      _MetricTile(
                        label: 'Unpaid',
                        value: data.unpaidVisitCount.toString(),
                        icon: Icons.pending_actions_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Visit Payments',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  if (data.items.isEmpty)
                    const Text('No visits in this date range.')
                  else
                    ...data.items.map((item) => _PaymentTile(item: item)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DateRangeBar extends ConsumerWidget {
  const _DateRangeBar({required this.range});

  final PaymentReportRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => _pickDate(context, ref, isStart: true),
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text('From ${shortDateFormat.format(range.startDate)}'),
        ),
        OutlinedButton.icon(
          onPressed: () => _pickDate(context, ref, isStart: false),
          icon: const Icon(Icons.event_outlined),
          label: Text('To ${shortDateFormat.format(range.endDate)}'),
        ),
        IconButton.filledTonal(
          tooltip: 'Today',
          onPressed: () {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            ref.read(paymentReportRangeProvider.notifier).state =
                PaymentReportRange(startDate: today, endDate: today);
          },
          icon: const Icon(Icons.today_outlined),
        ),
      ],
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    WidgetRef ref, {
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? range.startDate : range.endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    final current = ref.read(paymentReportRangeProvider);
    var start = isStart ? picked : current.startDate;
    var end = isStart ? current.endDate : picked;
    if (end.isBefore(start)) {
      final swap = start;
      start = end;
      end = swap;
    }
    ref.read(paymentReportRangeProvider.notifier).state = PaymentReportRange(
      startDate: start,
      endDate: end,
    );
  }
}

class _PaymentTile extends ConsumerWidget {
  const _PaymentTile({required this.item});

  final PaymentReportItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = item.isPaid
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;

    return Card(
      child: InkWell(
        onTap: () => context.push('/customers/${item.customerId}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final actions = _PaymentActions(
                item: item,
                onMarkUnpaid: () => _markUnpaid(context, ref),
                onPay: () => _showPaymentDialog(context, ref),
              );

              final content = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      item.isPaid
                          ? Icons.receipt_long_outlined
                          : Icons.pending_outlined,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: _PaymentDetails(item: item)),
                ],
              );

              if (constraints.maxWidth < 520) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    content,
                    const SizedBox(height: 14),
                    Align(alignment: Alignment.centerRight, child: actions),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: content),
                  const SizedBox(width: 12),
                  actions,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showPaymentDialog(BuildContext context, WidgetRef ref) async {
    final update = await showDialog<_PaymentUpdate>(
      context: context,
      builder: (dialogContext) => _PaymentDialog(item: item),
    );
    if (update == null) return;

    await ref
        .read(laundryRepositoryProvider)
        .updateVisitPayment(
          visitId: item.visitId,
          isPaid: true,
          freeLoadRedeemed: update.freeLoadRedeemed,
          paymentDate: update.paymentDate,
          paymentAmount: update.paymentAmount,
        );
    ref.invalidate(paymentReportProvider);
  }

  Future<void> _markUnpaid(BuildContext context, WidgetRef ref) async {
    await ref
        .read(laundryRepositoryProvider)
        .updateVisitPayment(
          visitId: item.visitId,
          isPaid: false,
          freeLoadRedeemed: false,
          paymentDate: DateTime.now(),
          paymentAmount: 0,
        );
    ref.invalidate(paymentReportProvider);
  }
}

class _PaymentDetails extends StatelessWidget {
  const _PaymentDetails({required this.item});

  final PaymentReportItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.customerName, style: textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          item.mobileNumber,
          style: textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          fullDateTimeFormat.format(item.visitDate),
          style: textTheme.bodyMedium,
        ),
        Text(_loadLabel(item), style: textTheme.bodyMedium),
        Text(
          item.isPaid
              ? 'Paid ${_money(item.paymentAmount ?? 0)}'
              : 'Not paid yet',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _PaymentActions extends StatelessWidget {
  const _PaymentActions({
    required this.item,
    required this.onMarkUnpaid,
    required this.onPay,
  });

  final PaymentReportItem item;
  final VoidCallback onMarkUnpaid;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        if (item.isPaid)
          TextButton.icon(
            onPressed: onMarkUnpaid,
            icon: const Icon(Icons.undo_outlined),
            label: const Text('Unpaid'),
          ),
        FilledButton.icon(
          onPressed: onPay,
          icon: Icon(
            item.isPaid ? Icons.edit_outlined : Icons.point_of_sale_outlined,
          ),
          label: Text(item.isPaid ? 'Edit' : 'Pay'),
        ),
      ],
    );
  }
}

class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog({required this.item});

  final PaymentReportItem item;

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  late final TextEditingController _amountController;
  late DateTime _paymentDate;
  late bool _freeLoadRedeemed;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.item.paymentAmount == null
          ? ''
          : widget.item.paymentAmount!.toStringAsFixed(2),
    );
    _paymentDate = widget.item.paymentDate ?? DateTime.now();
    _freeLoadRedeemed = widget.item.freeLoadRedeemed;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record Payment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount paid',
              prefixText: 'PHP ',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickPaymentDate,
            icon: const Icon(Icons.event_outlined),
            label: Text('Payment date ${shortDateFormat.format(_paymentDate)}'),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _freeLoadRedeemed,
            onChanged: (value) {
              setState(() => _freeLoadRedeemed = value ?? false);
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Free load redeemed'),
            subtitle: widget.item.canRedeemFreeLoad
                ? const Text('Customer has a free load available.')
                : const Text('Use only when honoring a free load.'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              _PaymentUpdate(
                paymentAmount: double.tryParse(_amountController.text) ?? 0,
                paymentDate: _paymentDate,
                freeLoadRedeemed: _freeLoadRedeemed,
              ),
            );
          },
          child: const Text('Save Payment'),
        ),
      ],
    );
  }

  Future<void> _pickPaymentDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _paymentDate = picked);
  }
}

class _PaymentUpdate {
  const _PaymentUpdate({
    required this.paymentAmount,
    required this.paymentDate,
    required this.freeLoadRedeemed,
  });

  final double paymentAmount;
  final DateTime paymentDate;
  final bool freeLoadRedeemed;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 136,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.titleMedium),
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _money(double amount) {
  return NumberFormat.currency(symbol: 'PHP ', decimalDigits: 2).format(amount);
}

String _loadLabel(PaymentReportItem item) {
  if (item.freeLoadRedeemed) {
    return '${item.loadCount} loads + free';
  }
  return '${item.loadCount} loads';
}
