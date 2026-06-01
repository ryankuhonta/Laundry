class RecentVisit {
  const RecentVisit({
    required this.visitId,
    required this.customerId,
    required this.customerName,
    required this.mobileNumber,
    required this.visitDate,
    required this.loadCount,
    required this.freeLoadRedeemed,
    required this.canRedeemFreeLoad,
    required this.isPaid,
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
  final bool canRedeemFreeLoad;
  final bool isPaid;
  final DateTime? paymentDate;
  final double? paymentAmount;
}
