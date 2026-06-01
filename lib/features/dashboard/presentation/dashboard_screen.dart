import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/exit_confirmation_scope.dart';
import '../../customers/application/customer_providers.dart';
import '../../customers/application/laundry_repository_provider.dart';
import '../../customers/domain/customer_profile.dart';
import '../../customers/domain/recent_visit.dart';
import '../../export/application/export_report_provider.dart';
import '../../staff_auth/application/staff_auth_provider.dart';
import '../application/dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final searchResults = ref.watch(customerSearchResultsProvider);

    return ExitConfirmationScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Staff Dashboard'),
          actions: [
            TextButton.icon(
              onPressed: () => _showThresholdDialog(context, ref),
              icon: const Icon(Icons.tune),
              label: const Text('Reward'),
            ),
            TextButton.icon(
              onPressed: () => context.push('/payments'),
              icon: const Icon(Icons.point_of_sale_outlined),
              label: const Text('Payments'),
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
            child: stats.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Text('Could not load dashboard: $error'),
              data: (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _MetricTile(
                        label: 'Today',
                        value: data.todayVisitCount.toString(),
                        icon: Icons.today_outlined,
                      ),
                      _MetricTile(
                        label: 'New',
                        value: data.todayNewCustomerCount.toString(),
                        icon: Icons.person_add_alt_outlined,
                      ),
                      _MetricTile(
                        label: 'Returning',
                        value: data.todayReturningCustomerCount.toString(),
                        icon: Icons.repeat_outlined,
                      ),
                      _MetricTile(
                        label: 'Reward',
                        value: '${data.rewardThreshold} loads',
                        icon: Icons.card_giftcard_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      onPressed: () => _exportReport(context, ref),
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('Export Excel'),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SearchBox(searchResults: searchResults),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 900;
                      final recent = _RecentVisitsList(
                        visits: data.recentVisits,
                        onEditLoads: (visit) =>
                            _showLoadCountDialog(context, ref, visit),
                      );
                      final nearReward = _NearRewardList(
                        customers: data.customersNearReward,
                      );

                      if (!wide) {
                        return Column(
                          children: [
                            recent,
                            const SizedBox(height: 24),
                            nearReward,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: recent),
                          const SizedBox(width: 24),
                          Expanded(child: nearReward),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showThresholdDialog(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(laundryRepositoryProvider);
    final currentThreshold = await repository.getRewardThreshold();
    if (!context.mounted) return;

    final threshold = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return _RewardThresholdDialog(initialThreshold: currentThreshold);
      },
    );

    if (threshold == null) return;
    await repository.updateRewardThreshold(threshold);
    ref.invalidate(dashboardStatsProvider);
  }

  Future<void> _exportReport(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Creating Excel export...')),
    );

    try {
      final path = await ref
          .read(exportReportServiceProvider)
          .exportExcelReport();
      messenger.showSnackBar(SnackBar(content: Text('Export saved: $path')));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not create export.')),
      );
    }
  }

  Future<void> _showLoadCountDialog(
    BuildContext context,
    WidgetRef ref,
    RecentVisit visit,
  ) async {
    final loadUpdate = await showDialog<_LoadUpdate>(
      context: context,
      builder: (dialogContext) {
        return _LoadCountDialog(
          customerName: visit.customerName,
          initialLoadCount: visit.loadCount,
        );
      },
    );

    if (loadUpdate == null) return;
    await ref
        .read(laundryRepositoryProvider)
        .updateVisitLoadCount(
          visitId: visit.visitId,
          loadCount: loadUpdate.loadCount,
        );
    ref.invalidate(dashboardStatsProvider);
  }
}

class _LoadUpdate {
  const _LoadUpdate({required this.loadCount});

  final int loadCount;
}

class _RewardThresholdDialog extends StatefulWidget {
  const _RewardThresholdDialog({required this.initialThreshold});

  final int initialThreshold;

  @override
  State<_RewardThresholdDialog> createState() => _RewardThresholdDialogState();
}

class _RewardThresholdDialogState extends State<_RewardThresholdDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialThreshold.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reward Threshold'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Laundry loads before free load',
          prefixIcon: Icon(Icons.card_giftcard_outlined),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(int.tryParse(_controller.text));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _LoadCountDialog extends StatefulWidget {
  const _LoadCountDialog({
    required this.customerName,
    required this.initialLoadCount,
  });

  final String customerName;
  final int initialLoadCount;

  @override
  State<_LoadCountDialog> createState() => _LoadCountDialogState();
}

class _LoadCountDialogState extends State<_LoadCountDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialLoadCount.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Laundry Loads'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Laundry loads for ${widget.customerName}',
          prefixIcon: const Icon(Icons.local_laundry_service_outlined),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop(_LoadUpdate(loadCount: int.tryParse(_controller.text) ?? 0));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
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
      width: 210,
      height: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 36),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineMedium,
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

class _SearchBox extends ConsumerWidget {
  const _SearchBox({required this.searchResults});

  final AsyncValue<List<CustomerProfile>> searchResults;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(customerSearchQueryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Customer Search',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search by name or mobile number',
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          ),
          style: const TextStyle(fontSize: 18),
          onChanged: (value) {
            ref.read(customerSearchQueryProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 12),
        if (query.trim().isNotEmpty)
          searchResults.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text('Search failed: $error'),
            data: (customers) => customers.isEmpty
                ? const Text('No matching customers found.')
                : Column(
                    children: customers.map((customer) {
                      return _CustomerResultTile(customer: customer);
                    }).toList(),
                  ),
          ),
      ],
    );
  }
}

class _CustomerResultTile extends StatelessWidget {
  const _CustomerResultTile({required this.customer});

  final CustomerProfile customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 16,
        leading: const Icon(Icons.person_outline),
        title: Text(customer.name),
        subtitle: Text(
          '${customer.mobileNumber} - ${customer.totalLoads} loads',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/customers/${customer.id}'),
      ),
    );
  }
}

class _RecentVisitsList extends StatelessWidget {
  const _RecentVisitsList({required this.visits, required this.onEditLoads});

  final List<RecentVisit> visits;
  final ValueChanged<RecentVisit> onEditLoads;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Recent Visits', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (visits.isEmpty)
          const Text('No visits recorded yet.')
        else
          ...visits.map(
            (visit) => Card(
              child: ListTile(
                minVerticalPadding: 14,
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(visit.customerName),
                subtitle: Text(
                  '${fullDateTimeFormat.format(visit.visitDate)} - ${visit.isPaid ? 'Paid' : 'Not paid yet'}',
                ),
                trailing: TextButton.icon(
                  onPressed: () => onEditLoads(visit),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(
                    visit.freeLoadRedeemed
                        ? '${visit.loadCount} loads + free'
                        : '${visit.loadCount} loads',
                  ),
                ),
                onTap: () => context.push('/customers/${visit.customerId}'),
              ),
            ),
          ),
      ],
    );
  }
}

class _NearRewardList extends StatelessWidget {
  const _NearRewardList({required this.customers});

  final List<CustomerProfile> customers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Near Reward', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (customers.isEmpty)
          const Text('No customers are near the reward threshold yet.')
        else
          ...customers.map(
            (customer) => Card(
              child: ListTile(
                minVerticalPadding: 14,
                leading: const Icon(Icons.card_giftcard_outlined),
                title: Text(customer.name),
                subtitle: Text(_rewardStatus(customer)),
                trailing: Text('${customer.totalLoads} loads'),
                onTap: () => context.push('/customers/${customer.id}'),
              ),
            ),
          ),
      ],
    );
  }

  String _rewardStatus(CustomerProfile customer) {
    if (customer.availableFreeLoads > 0) {
      return customer.availableFreeLoads == 1
          ? 'Free load available'
          : '${customer.availableFreeLoads} free loads available';
    }
    return '${customer.loadsUntilNextFreeLoad} loads to free load';
  }
}
