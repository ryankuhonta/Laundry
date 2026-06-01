import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../customers/application/laundry_repository_provider.dart';
import '../../customers/domain/dashboard_stats.dart';

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) {
  return ref.watch(laundryRepositoryProvider).watchDashboardStats();
});
