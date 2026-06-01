import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/customer_details/presentation/customer_details_screen.dart';
import '../../features/customer_kiosk/presentation/customer_kiosk_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/payments/presentation/payment_report_screen.dart';
import '../../features/staff_auth/application/staff_auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref
    ..listen<bool>(staffSessionUnlockedProvider, (_, __) {
      refreshNotifier.notify();
    })
    ..onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/kiosk',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final path = state.uri.path;
      final staffOnly =
          path == '/dashboard' ||
          path == '/payments' ||
          path.startsWith('/customers/');

      if (staffOnly && !ref.read(staffSessionUnlockedProvider)) {
        return '/kiosk';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/kiosk',
        builder: (context, state) => const CustomerKioskScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentReportScreen(),
      ),
      GoRoute(
        path: '/customers/:id',
        builder: (context, state) {
          final customerId = int.parse(state.pathParameters['id']!);
          return CustomerDetailsScreen(customerId: customerId);
        },
      ),
    ],
  );
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
