import 'customer_profile.dart';
import 'recent_visit.dart';

class DashboardStats {
  const DashboardStats({
    required this.todayVisitCount,
    required this.todayNewCustomerCount,
    required this.todayReturningCustomerCount,
    required this.recentVisits,
    required this.customersNearReward,
    required this.rewardThreshold,
  });

  final int todayVisitCount;
  final int todayNewCustomerCount;
  final int todayReturningCustomerCount;
  final List<RecentVisit> recentVisits;
  final List<CustomerProfile> customersNearReward;
  final int rewardThreshold;
}
