class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.mobileNumber,
    required this.name,
    required this.address,
    required this.createdAt,
    required this.totalVisits,
    required this.totalLoads,
    this.freeLoadsRedeemed = 0,
    this.availableFreeLoads = 0,
    this.loadsUntilNextFreeLoad = 0,
    this.lastVisitDate,
  });

  final int id;
  final String mobileNumber;
  final String name;
  final String address;
  final DateTime createdAt;
  final int totalVisits;
  final int totalLoads;
  final int freeLoadsRedeemed;
  final int availableFreeLoads;
  final int loadsUntilNextFreeLoad;
  final DateTime? lastVisitDate;
}
