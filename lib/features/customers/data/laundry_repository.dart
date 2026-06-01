import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/customer_profile.dart';
import '../domain/dashboard_stats.dart';
import '../domain/recent_visit.dart';
import '../../export/domain/export_snapshot.dart';
import '../../payments/domain/payment_report.dart';

class VisitSubmissionResult {
  const VisitSubmissionResult({
    required this.customer,
    required this.visitId,
    required this.totalLoads,
    required this.rewardThreshold,
    required this.availableFreeLoads,
    required this.isNewCustomer,
  });

  final CustomerRecord customer;
  final int visitId;
  final int totalLoads;
  final int rewardThreshold;
  final int availableFreeLoads;
  final bool isNewCustomer;
}

class LoyaltyProgress {
  const LoyaltyProgress({
    required this.recordedLoads,
    required this.freeLoadsEarned,
    required this.freeLoadsRedeemed,
    required this.availableFreeLoads,
    required this.loadsUntilNextFreeLoad,
  });

  final int recordedLoads;
  final int freeLoadsEarned;
  final int freeLoadsRedeemed;
  final int availableFreeLoads;
  final int loadsUntilNextFreeLoad;
}

class LaundryRepository {
  LaundryRepository(this._database);

  static const _pinHashPrefix = 'sha256';

  final AppDatabase _database;

  Future<CustomerRecord?> findCustomerByMobile(String mobileNumber) {
    final normalized = _normalizeMobile(mobileNumber);
    return (_database.select(_database.customers)
          ..where((customer) => customer.mobileNumber.equals(normalized)))
        .getSingleOrNull();
  }

  Future<VisitSubmissionResult> recordVisit({
    required String name,
    required String mobileNumber,
    required String address,
    required String signatureImagePath,
  }) async {
    final normalizedMobile = _normalizeMobile(mobileNumber);

    return _database.transaction(() async {
      final existing = await findCustomerByMobile(normalizedMobile);
      final isNewCustomer = existing == null;

      final customer = isNewCustomer
          ? await _database
                .into(_database.customers)
                .insertReturning(
                  CustomersCompanion.insert(
                    mobileNumber: normalizedMobile,
                    name: name.trim(),
                    address: address.trim(),
                  ),
                )
          : await _updateCustomer(existing.id, name, address);

      final visitId = await _database
          .into(_database.visits)
          .insert(
            VisitsCompanion.insert(
              customerId: customer.id,
              signatureImagePath: signatureImagePath,
            ),
          );

      final totalLoads = await getTotalLoads(customer.id);
      final threshold = await getRewardThreshold();
      final progress = await getLoyaltyProgress(customer.id);

      return VisitSubmissionResult(
        customer: customer,
        visitId: visitId,
        totalLoads: totalLoads,
        rewardThreshold: threshold,
        availableFreeLoads: progress.availableFreeLoads,
        isNewCustomer: isNewCustomer,
      );
    });
  }

  Future<void> updateVisitLoadCount({
    required int visitId,
    required int loadCount,
  }) async {
    final safeLoadCount = loadCount < 0 ? 0 : loadCount;
    await (_database.update(_database.visits)
          ..where((visit) => visit.id.equals(visitId)))
        .write(VisitsCompanion(loadCount: Value(safeLoadCount)));
  }

  Future<void> updateVisitPayment({
    required int visitId,
    required bool isPaid,
    required bool freeLoadRedeemed,
    required DateTime paymentDate,
    required double paymentAmount,
  }) async {
    final safeAmount = paymentAmount < 0 ? 0.0 : paymentAmount;
    await (_database.update(
      _database.visits,
    )..where((visit) => visit.id.equals(visitId))).write(
      VisitsCompanion(
        isPaid: Value(isPaid),
        freeLoadRedeemed: Value(isPaid && freeLoadRedeemed),
        paymentDate: Value(isPaid ? paymentDate : null),
        paymentAmount: Value(isPaid ? safeAmount : null),
      ),
    );
  }

  Future<CustomerRecord> _updateCustomer(
    int customerId,
    String name,
    String address,
  ) async {
    await (_database.update(
      _database.customers,
    )..where((customer) => customer.id.equals(customerId))).write(
      CustomersCompanion(
        name: Value(name.trim()),
        address: Value(address.trim()),
      ),
    );

    return (_database.select(
      _database.customers,
    )..where((customer) => customer.id.equals(customerId))).getSingle();
  }

  Future<int> getRewardThreshold() async {
    final settings = await (_database.select(
      _database.loyaltySettings,
    )..where((row) => row.id.equals(1))).getSingleOrNull();
    return settings?.rewardThreshold ?? 5;
  }

  Future<void> updateRewardThreshold(int threshold) {
    final safeThreshold = threshold < 1 ? 1 : threshold;
    return _database
        .into(_database.loyaltySettings)
        .insertOnConflictUpdate(
          LoyaltySettingsCompanion(
            id: const Value(1),
            rewardThreshold: Value(safeThreshold),
          ),
        );
  }

  Future<bool> hasStaffPin() async {
    final settings = await (_database.select(
      _database.loyaltySettings,
    )..where((row) => row.id.equals(1))).getSingleOrNull();
    return settings?.staffPin?.isNotEmpty ?? false;
  }

  Future<void> setStaffPin(String pin) {
    final hashedPin = _hashPin(pin);
    return _database
        .into(_database.loyaltySettings)
        .insertOnConflictUpdate(
          LoyaltySettingsCompanion(
            id: const Value(1),
            staffPin: Value(hashedPin),
          ),
        );
  }

  Future<bool> verifyStaffPin(String pin) async {
    final settings = await (_database.select(
      _database.loyaltySettings,
    )..where((row) => row.id.equals(1))).getSingleOrNull();
    final storedPin = settings?.staffPin;
    if (storedPin == null || storedPin.isEmpty) return false;

    if (_isHashedPin(storedPin)) {
      return _verifyHashedPin(pin, storedPin);
    }

    final isLegacyMatch = storedPin == pin;
    if (isLegacyMatch) {
      await setStaffPin(pin);
    }
    return isLegacyMatch;
  }

  Future<int> getTotalLoads(int customerId) async {
    final visits = await (_database.select(
      _database.visits,
    )..where((visit) => visit.customerId.equals(customerId))).get();
    return visits.fold<int>(0, (total, visit) => total + visit.loadCount);
  }

  Future<LoyaltyProgress> getLoyaltyProgress(int customerId) async {
    final threshold = await getRewardThreshold();
    final visits = await (_database.select(
      _database.visits,
    )..where((visit) => visit.customerId.equals(customerId))).get();
    return _calculateLoyaltyProgress(visits, threshold);
  }

  Future<CustomerProfile?> getCustomerProfile(int customerId) async {
    final customer = await (_database.select(
      _database.customers,
    )..where((row) => row.id.equals(customerId))).getSingleOrNull();
    if (customer == null) return null;

    return _profileFromCustomer(customer);
  }

  Stream<CustomerProfile?> watchCustomerProfile(int customerId) {
    return (_database.select(
      _database.customers,
    )..where((row) => row.id.equals(customerId))).watchSingleOrNull().asyncMap(
      (customer) => customer == null ? null : _profileFromCustomer(customer),
    );
  }

  Stream<List<VisitRecord>> watchVisitsForCustomer(int customerId) {
    return (_database.select(_database.visits)
          ..where((visit) => visit.customerId.equals(customerId))
          ..orderBy([
            (visit) => OrderingTerm(
              expression: visit.visitDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  Future<List<CustomerProfile>> searchCustomers(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final rows =
        await (_database.select(_database.customers)
              ..where(
                (customer) =>
                    customer.name.like('%$trimmed%') |
                    customer.mobileNumber.like('%$trimmed%'),
              )
              ..limit(20))
            .get();

    final profiles = <CustomerProfile>[];
    for (final customer in rows) {
      profiles.add(await _profileFromCustomer(customer));
    }
    return profiles;
  }

  Stream<DashboardStats> watchDashboardStats() {
    return _database.select(_database.visits).watch().asyncMap((_) {
      return getDashboardStats();
    });
  }

  Stream<PaymentReport> watchPaymentReport({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _database.select(_database.visits).watch().asyncMap((_) {
      return getPaymentReport(startDate: startDate, endDate: endDate);
    });
  }

  Future<PaymentReport> getPaymentReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);
    final exclusiveEnd = normalizedEnd.add(const Duration(days: 1));

    final joined =
        _database.select(_database.visits).join([
          innerJoin(
            _database.customers,
            _database.customers.id.equalsExp(_database.visits.customerId),
          ),
        ])..orderBy([
          OrderingTerm(
            expression: _database.visits.visitDate,
            mode: OrderingMode.desc,
          ),
        ]);

    final rows = await joined.get();
    final threshold = await getRewardThreshold();
    final items = <PaymentReportItem>[];
    var paidVisitCount = 0;
    var unpaidVisitCount = 0;
    var salesTotal = 0.0;

    for (final row in rows) {
      final visit = row.readTable(_database.visits);
      final customer = row.readTable(_database.customers);
      final paymentDate = visit.paymentDate;
      final visitInRange =
          !visit.visitDate.isBefore(normalizedStart) &&
          visit.visitDate.isBefore(exclusiveEnd);
      final paymentInRange =
          visit.isPaid &&
          paymentDate != null &&
          !paymentDate.isBefore(normalizedStart) &&
          paymentDate.isBefore(exclusiveEnd);

      if (visit.isPaid) {
        if (!paymentInRange) continue;
        paidVisitCount++;
        salesTotal += visit.paymentAmount ?? 0;
      } else {
        if (!visitInRange) continue;
        unpaidVisitCount++;
      }

      final progressBeforeVisit = await _loyaltyProgressBeforeVisit(
        customerId: customer.id,
        visitDate: visit.visitDate,
        threshold: threshold,
      );
      items.add(
        PaymentReportItem(
          visitId: visit.id,
          customerId: customer.id,
          customerName: customer.name,
          mobileNumber: customer.mobileNumber,
          visitDate: visit.visitDate,
          loadCount: visit.loadCount,
          freeLoadRedeemed: visit.freeLoadRedeemed,
          canRedeemFreeLoad: progressBeforeVisit.availableFreeLoads > 0,
          isPaid: visit.isPaid,
          paymentDate: visit.paymentDate,
          paymentAmount: visit.paymentAmount,
        ),
      );
    }

    return PaymentReport(
      startDate: normalizedStart,
      endDate: normalizedEnd,
      items: items,
      salesTotal: salesTotal,
      paidVisitCount: paidVisitCount,
      unpaidVisitCount: unpaidVisitCount,
    );
  }

  Future<DashboardStats> getDashboardStats() async {
    final threshold = await getRewardThreshold();
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    final todayVisits =
        await (_database.select(_database.visits)..where(
              (visit) =>
                  visit.visitDate.isBiggerOrEqualValue(startOfToday) &
                  visit.visitDate.isSmallerThanValue(startOfTomorrow),
            ))
            .get();

    final newCustomerIds = <int>{};
    final returningCustomerIds = <int>{};
    for (final visit in todayVisits) {
      final priorVisits =
          await (_database.select(_database.visits)
                ..where(
                  (row) =>
                      row.customerId.equals(visit.customerId) &
                      row.visitDate.isSmallerThanValue(startOfToday),
                )
                ..limit(1))
              .get();

      if (priorVisits.isEmpty) {
        newCustomerIds.add(visit.customerId);
      } else {
        returningCustomerIds.add(visit.customerId);
      }
    }

    final recentVisits = await _recentVisits(limit: 8);
    final nearReward = await _customersNearReward(threshold);

    return DashboardStats(
      todayVisitCount: todayVisits.length,
      todayNewCustomerCount: newCustomerIds.length,
      todayReturningCustomerCount: returningCustomerIds.length,
      recentVisits: recentVisits,
      customersNearReward: nearReward,
      rewardThreshold: threshold,
    );
  }

  Future<ExportSnapshot> getExportSnapshot() async {
    final customers = await _database.select(_database.customers).get();
    final profiles = <CustomerProfile>[];
    for (final customer in customers) {
      profiles.add(await _profileFromCustomer(customer));
    }
    profiles.sort((a, b) => a.name.compareTo(b.name));

    final joined =
        _database.select(_database.visits).join([
          innerJoin(
            _database.customers,
            _database.customers.id.equalsExp(_database.visits.customerId),
          ),
        ])..orderBy([
          OrderingTerm(
            expression: _database.visits.visitDate,
            mode: OrderingMode.desc,
          ),
        ]);

    final rows = await joined.get();
    final threshold = await getRewardThreshold();
    final visits = <ExportVisitItem>[];
    for (final row in rows) {
      final visit = row.readTable(_database.visits);
      final customer = row.readTable(_database.customers);
      visits.add(
        ExportVisitItem(
          visitId: visit.id,
          customerId: customer.id,
          customerName: customer.name,
          mobileNumber: customer.mobileNumber,
          visitDate: visit.visitDate,
          loadCount: visit.loadCount,
          freeLoadRedeemed: visit.freeLoadRedeemed,
          isPaid: visit.isPaid,
          paymentDate: visit.paymentDate,
          paymentAmount: visit.paymentAmount,
          signatureImagePath: visit.signatureImagePath,
        ),
      );
    }

    return ExportSnapshot(
      exportedAt: DateTime.now(),
      rewardThreshold: threshold,
      customers: profiles,
      visits: visits,
    );
  }

  Future<List<RecentVisit>> _recentVisits({required int limit}) async {
    final joined =
        _database.select(_database.visits).join([
            innerJoin(
              _database.customers,
              _database.customers.id.equalsExp(_database.visits.customerId),
            ),
          ])
          ..orderBy([
            OrderingTerm(
              expression: _database.visits.visitDate,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit);

    final rows = await joined.get();
    final recentVisits = <RecentVisit>[];
    for (final row in rows) {
      final visit = row.readTable(_database.visits);
      final customer = row.readTable(_database.customers);
      final progressBeforeVisit = await _loyaltyProgressBeforeVisit(
        customerId: customer.id,
        visitDate: visit.visitDate,
        threshold: await getRewardThreshold(),
      );

      recentVisits.add(
        RecentVisit(
          visitId: visit.id,
          customerId: customer.id,
          customerName: customer.name,
          mobileNumber: customer.mobileNumber,
          visitDate: visit.visitDate,
          loadCount: visit.loadCount,
          freeLoadRedeemed: visit.freeLoadRedeemed,
          canRedeemFreeLoad: progressBeforeVisit.availableFreeLoads > 0,
          isPaid: visit.isPaid,
          paymentDate: visit.paymentDate,
          paymentAmount: visit.paymentAmount,
        ),
      );
    }
    return recentVisits;
  }

  Future<List<CustomerProfile>> _customersNearReward(int threshold) async {
    final rows = await _database.select(_database.customers).get();
    final profiles = <CustomerProfile>[];

    for (final customer in rows) {
      final profile = await _profileFromCustomer(customer);
      if (profile.availableFreeLoads > 0 ||
          profile.loadsUntilNextFreeLoad <= 2) {
        profiles.add(profile);
      }
    }

    profiles.sort((a, b) => b.totalLoads.compareTo(a.totalLoads));
    return profiles.take(8).toList();
  }

  Future<CustomerProfile> _profileFromCustomer(CustomerRecord customer) async {
    final visits =
        await (_database.select(_database.visits)
              ..where((visit) => visit.customerId.equals(customer.id))
              ..orderBy([
                (visit) => OrderingTerm(
                  expression: visit.visitDate,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    final totalLoads = visits.fold<int>(
      0,
      (total, visit) => total + visit.loadCount,
    );
    final progress = _calculateLoyaltyProgress(
      visits,
      await getRewardThreshold(),
    );

    return CustomerProfile(
      id: customer.id,
      mobileNumber: customer.mobileNumber,
      name: customer.name,
      address: customer.address,
      createdAt: customer.createdAt,
      totalVisits: visits.length,
      totalLoads: totalLoads,
      freeLoadsRedeemed: progress.freeLoadsRedeemed,
      availableFreeLoads: progress.availableFreeLoads,
      loadsUntilNextFreeLoad: progress.loadsUntilNextFreeLoad,
      lastVisitDate: visits.isEmpty ? null : visits.first.visitDate,
    );
  }

  Future<LoyaltyProgress> _loyaltyProgressBeforeVisit({
    required int customerId,
    required DateTime visitDate,
    required int threshold,
  }) async {
    final visits =
        await (_database.select(_database.visits)..where(
              (visit) =>
                  visit.customerId.equals(customerId) &
                  visit.isPaid.equals(true) &
                  visit.visitDate.isSmallerThanValue(visitDate),
            ))
            .get();
    return _calculateLoyaltyProgress(visits, threshold);
  }

  LoyaltyProgress _calculateLoyaltyProgress(
    List<VisitRecord> visits,
    int threshold,
  ) {
    final safeThreshold = threshold < 1 ? 1 : threshold;
    final paidVisits = visits.where((visit) => visit.isPaid);
    final recordedLoads = paidVisits.fold<int>(
      0,
      (total, visit) => total + visit.loadCount,
    );
    final freeLoadsRedeemed = paidVisits
        .where((visit) => visit.freeLoadRedeemed)
        .length;
    final freeLoadsEarned = recordedLoads ~/ safeThreshold;
    final availableFreeLoads = freeLoadsEarned - freeLoadsRedeemed;
    final recordedLoadsRemainder = recordedLoads % safeThreshold;

    return LoyaltyProgress(
      recordedLoads: recordedLoads,
      freeLoadsEarned: freeLoadsEarned,
      freeLoadsRedeemed: freeLoadsRedeemed,
      availableFreeLoads: availableFreeLoads < 0 ? 0 : availableFreeLoads,
      loadsUntilNextFreeLoad: safeThreshold - recordedLoadsRemainder,
    );
  }

  String _normalizeMobile(String mobileNumber) {
    return mobileNumber.replaceAll(RegExp(r'\s+'), '').trim();
  }

  String _hashPin(String pin) {
    final saltBytes = List<int>.generate(
      16,
      (_) => Random.secure().nextInt(256),
    );
    final salt = base64Url.encode(saltBytes);
    final digest = sha256.convert(utf8.encode('$salt:$pin'));
    return '$_pinHashPrefix:$salt:$digest';
  }

  bool _isHashedPin(String value) => value.startsWith('$_pinHashPrefix:');

  bool _verifyHashedPin(String pin, String storedPin) {
    final parts = storedPin.split(':');
    if (parts.length != 3 || parts.first != _pinHashPrefix) return false;
    final digest = sha256.convert(utf8.encode('${parts[1]}:$pin'));
    return digest.toString() == parts[2];
  }
}
