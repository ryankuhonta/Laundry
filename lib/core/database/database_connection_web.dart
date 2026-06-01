import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

QueryExecutor createDatabaseConnection(String name) {
  return WebDatabase.withStorage(DriftWebStorage(name));
}
