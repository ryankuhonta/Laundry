import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/laundry_repository.dart';

final laundryRepositoryProvider = Provider<LaundryRepository>((ref) {
  return LaundryRepository(ref.watch(appDatabaseProvider));
});
