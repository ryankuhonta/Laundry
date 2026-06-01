import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_formatters.dart';
import '../../customers/application/customer_providers.dart';

class CustomerDetailsScreen extends ConsumerWidget {
  const CustomerDetailsScreen({required this.customerId, super.key});

  final int customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(customerProfileProvider(customerId));
    final visits = ref.watch(customerVisitsProvider(customerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Could not load customer: $error')),
          data: (customer) {
            if (customer == null) {
              return const Center(child: Text('Customer not found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 56),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                Text(
                                  customer.mobileNumber,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        customer.address,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _InfoTile(
                            label: 'Total visits',
                            value: '${customer.totalVisits}',
                          ),
                          _InfoTile(
                            label: 'Total loads',
                            value: '${customer.totalLoads}',
                          ),
                          _InfoTile(
                            label: 'Free available',
                            value: '${customer.availableFreeLoads}',
                          ),
                          _InfoTile(
                            label: 'Free redeemed',
                            value: '${customer.freeLoadsRedeemed}',
                          ),
                          _InfoTile(
                            label: 'Last visit',
                            value: customer.lastVisitDate == null
                                ? 'None'
                                : shortDateFormat.format(
                                    customer.lastVisitDate!,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Visit History',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      visits.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (error, stackTrace) =>
                            Text('Could not load visits: $error'),
                        data: (items) => items.isEmpty
                            ? const Text('No visits recorded.')
                            : Column(
                                children: items.map((visit) {
                                  return Card(
                                    child: ListTile(
                                      minVerticalPadding: 14,
                                      leading: const Icon(
                                        Icons.event_available_outlined,
                                      ),
                                      title: Text(
                                        fullDateTimeFormat.format(
                                          visit.visitDate,
                                        ),
                                      ),
                                      subtitle: Text(
                                        visit.isPaid
                                            ? 'Paid on ${shortDateFormat.format(visit.paymentDate ?? visit.visitDate)}'
                                            : 'Not paid yet',
                                      ),
                                      trailing: Text(
                                        visit.freeLoadRedeemed
                                            ? '${visit.loadCount} loads + free'
                                            : '${visit.loadCount} loads',
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 110,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}
