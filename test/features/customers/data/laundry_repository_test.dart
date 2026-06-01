import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_loyalty_program/core/database/app_database.dart';
import 'package:laundry_loyalty_program/features/customers/data/laundry_repository.dart';

void main() {
  late AppDatabase database;
  late LaundryRepository repository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LaundryRepository(database);
    await database.seedDefaults();
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'redeemed free load does not subtract from paid load progress',
    () async {
      final firstVisit = await repository.recordVisit(
        name: 'Qert',
        mobileNumber: '09171234567',
        address: 'Manila',
        signatureImagePath: 'signature-1.png',
      );
      await repository.updateVisitLoadCount(
        visitId: firstVisit.visitId,
        loadCount: 2,
      );
      await repository.updateVisitPayment(
        visitId: firstVisit.visitId,
        isPaid: true,
        freeLoadRedeemed: false,
        paymentDate: DateTime(2026, 5, 27),
        paymentAmount: 200,
      );

      final secondVisit = await repository.recordVisit(
        name: 'Qert',
        mobileNumber: '09171234567',
        address: 'Manila',
        signatureImagePath: 'signature-2.png',
      );
      await repository.updateVisitLoadCount(
        visitId: secondVisit.visitId,
        loadCount: 2,
      );
      await repository.updateVisitPayment(
        visitId: secondVisit.visitId,
        isPaid: true,
        freeLoadRedeemed: false,
        paymentDate: DateTime(2026, 5, 27),
        paymentAmount: 200,
      );

      final thirdVisit = await repository.recordVisit(
        name: 'Qert',
        mobileNumber: '09171234567',
        address: 'Manila',
        signatureImagePath: 'signature-3.png',
      );
      await repository.updateVisitLoadCount(
        visitId: thirdVisit.visitId,
        loadCount: 1,
      );
      await repository.updateVisitPayment(
        visitId: thirdVisit.visitId,
        isPaid: true,
        freeLoadRedeemed: true,
        paymentDate: DateTime(2026, 5, 27),
        paymentAmount: 100,
      );

      final profile = await repository.getCustomerProfile(
        firstVisit.customer.id,
      );
      final stats = await repository.getDashboardStats();

      expect(profile?.totalLoads, 5);
      expect(profile?.freeLoadsRedeemed, 1);
      expect(profile?.availableFreeLoads, 0);
      expect(profile?.loadsUntilNextFreeLoad, 5);
      expect(
        stats.customersNearReward.map((customer) => customer.id),
        isNot(contains(firstVisit.customer.id)),
      );
    },
  );

  test('payment report includes paid visits by payment date', () async {
    final visit = await repository.recordVisit(
      name: 'Late Payer',
      mobileNumber: '09170000001',
      address: 'Manila',
      signatureImagePath: 'signature-late.png',
    );
    await (database.update(
      database.visits,
    )..where((row) => row.id.equals(visit.visitId))).write(
      VisitsCompanion(
        visitDate: Value(DateTime(2026, 5, 30, 10)),
        loadCount: const Value(2),
      ),
    );
    await repository.updateVisitPayment(
      visitId: visit.visitId,
      isPaid: true,
      freeLoadRedeemed: false,
      paymentDate: DateTime(2026, 5, 31, 9),
      paymentAmount: 250,
    );

    final report = await repository.getPaymentReport(
      startDate: DateTime(2026, 5, 31),
      endDate: DateTime(2026, 5, 31),
    );

    expect(report.salesTotal, 250);
    expect(report.paidVisitCount, 1);
    expect(report.unpaidVisitCount, 0);
    expect(report.items.single.visitId, visit.visitId);
  });

  test('payment report keeps unpaid visits by visit date', () async {
    final visit = await repository.recordVisit(
      name: 'Unpaid Customer',
      mobileNumber: '09170000002',
      address: 'Manila',
      signatureImagePath: 'signature-unpaid.png',
    );
    await (database.update(
      database.visits,
    )..where((row) => row.id.equals(visit.visitId))).write(
      VisitsCompanion(
        visitDate: Value(DateTime(2026, 5, 31, 10)),
        loadCount: const Value(3),
      ),
    );

    final report = await repository.getPaymentReport(
      startDate: DateTime(2026, 5, 31),
      endDate: DateTime(2026, 5, 31),
    );

    expect(report.salesTotal, 0);
    expect(report.paidVisitCount, 0);
    expect(report.unpaidVisitCount, 1);
    expect(report.items.single.visitId, visit.visitId);
  });

  test('staff pin is hashed when saved', () async {
    await repository.setStaffPin('123456');

    final settings = await database
        .select(database.loyaltySettings)
        .getSingle();

    expect(settings.staffPin, isNot('123456'));
    expect(settings.staffPin, startsWith('sha256:'));
    expect(await repository.verifyStaffPin('123456'), isTrue);
    expect(await repository.verifyStaffPin('654321'), isFalse);
  });

  test(
    'legacy plaintext staff pin migrates after successful verification',
    () async {
      await database
          .into(database.loyaltySettings)
          .insertOnConflictUpdate(
            const LoyaltySettingsCompanion(
              id: Value(1),
              staffPin: Value('123456'),
            ),
          );

      expect(await repository.verifyStaffPin('000000'), isFalse);
      expect(await repository.verifyStaffPin('123456'), isTrue);

      final settings = await database
          .select(database.loyaltySettings)
          .getSingle();
      expect(settings.staffPin, isNot('123456'));
      expect(settings.staffPin, startsWith('sha256:'));
    },
  );
}
