import 'package:drift/drift.dart';

import 'database_connection_stub.dart'
    if (dart.library.html) 'database_connection_web.dart'
    if (dart.library.io) 'database_connection_native.dart';

QueryExecutor openDatabaseConnection(String name) {
  return createDatabaseConnection(name);
}
