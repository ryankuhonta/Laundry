import '../../customers/domain/customer_profile.dart';

class ExportSnapshot {
  const ExportSnapshot({
    required this.exportedAt,
    required this.rewardThreshold,
    required this.customers,
    required this.visits,
  });

  final DateTime exportedAt;
  final int rewardThreshold;
  final List<CustomerProfile> customers;
  final List<ExportVisitItem> visits;

  int get totalCustomers => customers.length;

  int get totalVisits => visits.length;

  int get paidVisits => visits.where((visit) => visit.isPaid).length;

  int get unpaidVisits => visits.where((visit) => !visit.isPaid).length;

  int get totalPaidLoads => visits
      .where((visit) => visit.isPaid)
      .fold(0, (total, visit) => total + visit.loadCount);

  int get freeLoadsRedeemed =>
      visits.where((visit) => visit.freeLoadRedeemed).length;

  double get totalSales => visits
      .where((visit) => visit.isPaid)
      .fold(0, (total, visit) => total + (visit.paymentAmount ?? 0));
}

class ExportVisitItem {
  const ExportVisitItem({
    required this.visitId,
    required this.customerId,
    required this.customerName,
    required this.mobileNumber,
    required this.visitDate,
    required this.loadCount,
    required this.freeLoadRedeemed,
    required this.isPaid,
    required this.signatureImagePath,
    this.paymentDate,
    this.paymentAmount,
  });

  final int visitId;
  final int customerId;
  final String customerName;
  final String mobileNumber;
  final DateTime visitDate;
  final int loadCount;
  final bool freeLoadRedeemed;
  final bool isPaid;
  final DateTime? paymentDate;
  final double? paymentAmount;
  final String signatureImagePath;
}
