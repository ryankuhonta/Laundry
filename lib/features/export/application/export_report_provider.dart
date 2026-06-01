import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../customers/application/laundry_repository_provider.dart';
import 'export_report_service.dart';

final exportReportServiceProvider = Provider<ExportReportService>((ref) {
  return ExportReportService(ref.watch(laundryRepositoryProvider));
});
