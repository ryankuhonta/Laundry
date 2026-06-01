import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_loyalty_program/features/customers/domain/customer_profile.dart';

void main() {
  test('CustomerProfile carries loyalty summary fields', () {
    final createdAt = DateTime(2026, 5, 20);
    final lastVisit = DateTime(2026, 5, 21);

    final profile = CustomerProfile(
      id: 1,
      mobileNumber: '09171234567',
      name: 'Maria Santos',
      address: 'Manila',
      createdAt: createdAt,
      totalVisits: 3,
      totalLoads: 3,
      lastVisitDate: lastVisit,
    );

    expect(profile.totalVisits, 3);
    expect(profile.totalLoads, 3);
    expect(profile.lastVisitDate, lastVisit);
  });
}
