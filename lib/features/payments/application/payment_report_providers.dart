import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../customers/application/laundry_repository_provider.dart';
import '../domain/payment_report.dart';

class PaymentReportRange {
  const PaymentReportRange({required this.startDate, required this.endDate});

  final DateTime startDate;
  final DateTime endDate;
}

final paymentReportRangeProvider = StateProvider<PaymentReportRange>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return PaymentReportRange(startDate: today, endDate: today);
});

final paymentReportProvider = StreamProvider<PaymentReport>((ref) {
  final range = ref.watch(paymentReportRangeProvider);
  return ref
      .watch(laundryRepositoryProvider)
      .watchPaymentReport(startDate: range.startDate, endDate: range.endDate);
});
