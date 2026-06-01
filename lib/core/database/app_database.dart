import 'package:drift/drift.dart';

import 'database_connection.dart';

part 'app_database.g.dart';

@DataClassName('CustomerRecord')
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mobileNumber => text().unique()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
}

@DataClassName('VisitRecord')
class Visits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id)();
  DateTimeColumn get visitDate => dateTime().clientDefault(DateTime.now)();
  TextColumn get signatureImagePath => text()();
  IntColumn get loadCount => integer().withDefault(const Constant(0))();
  BoolColumn get freeLoadRedeemed =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paymentDate => dateTime().nullable()();
  RealColumn get paymentAmount => real().nullable()();
}

@DataClassName('LoyaltySettingRecord')
class LoyaltySettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get rewardThreshold => integer().withDefault(const Constant(5))();
  TextColumn get staffPin => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Customers, Visits, LoyaltySettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(visits, visits.loadCount);
        await update(
          loyaltySettings,
        ).write(const LoyaltySettingsCompanion(rewardThreshold: Value(5)));
      }
      if (from < 3) {
        await m.addColumn(visits, visits.freeLoadRedeemed);
      }
      if (from < 4) {
        await m.addColumn(visits, visits.isPaid);
        await m.addColumn(visits, visits.paymentDate);
        await m.addColumn(visits, visits.paymentAmount);
      }
      if (from < 5) {
        await m.addColumn(loyaltySettings, loyaltySettings.staffPin);
      }
    },
  );

  Future<void> seedDefaults() async {
    await into(loyaltySettings).insertOnConflictUpdate(
      const LoyaltySettingsCompanion(id: Value(1), rewardThreshold: Value(5)),
    );
  }
}

QueryExecutor _openConnection() {
  return openDatabaseConnection('laundry_loyalty.sqlite');
}
