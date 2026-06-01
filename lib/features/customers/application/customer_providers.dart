import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/customer_profile.dart';
import 'laundry_repository_provider.dart';

final customerSearchQueryProvider = StateProvider<String>((ref) => '');

final customerSearchResultsProvider =
    FutureProvider.autoDispose<List<CustomerProfile>>((ref) {
      final query = ref.watch(customerSearchQueryProvider);
      return ref.watch(laundryRepositoryProvider).searchCustomers(query);
    });

final customerProfileProvider = StreamProvider.autoDispose
    .family<CustomerProfile?, int>((ref, customerId) {
      return ref
          .watch(laundryRepositoryProvider)
          .watchCustomerProfile(customerId);
    });

final customerVisitsProvider = StreamProvider.autoDispose
    .family<List<VisitRecord>, int>((ref, customerId) {
      return ref
          .watch(laundryRepositoryProvider)
          .watchVisitsForCustomer(customerId);
    });
