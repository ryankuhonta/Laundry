import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import '../../customers/application/laundry_repository_provider.dart';
import '../../customers/data/laundry_repository.dart';

class KioskFormState {
  const KioskFormState({
    this.matchedCustomer,
    this.lastSubmission,
    this.message,
  });

  final CustomerRecord? matchedCustomer;
  final VisitSubmissionResult? lastSubmission;
  final String? message;

  KioskFormState copyWith({
    CustomerRecord? matchedCustomer,
    VisitSubmissionResult? lastSubmission,
    String? message,
    bool clearMatchedCustomer = false,
    bool clearSubmission = false,
    bool clearMessage = false,
  }) {
    return KioskFormState(
      matchedCustomer: clearMatchedCustomer
          ? null
          : matchedCustomer ?? this.matchedCustomer,
      lastSubmission: clearSubmission
          ? null
          : lastSubmission ?? this.lastSubmission,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}

final kioskFormControllerProvider =
    AsyncNotifierProvider.autoDispose<KioskFormController, KioskFormState>(
      KioskFormController.new,
    );

class KioskFormController extends AutoDisposeAsyncNotifier<KioskFormState> {
  @override
  Future<KioskFormState> build() async {
    return const KioskFormState();
  }

  Future<void> lookupMobile(String mobileNumber) async {
    final trimmed = mobileNumber.trim();
    if (trimmed.length < 6) {
      state = const AsyncData(KioskFormState());
      return;
    }

    final repository = ref.read(laundryRepositoryProvider);
    final customer = await repository.findCustomerByMobile(trimmed);
    final current = state.valueOrNull ?? const KioskFormState();

    state = AsyncData(
      current.copyWith(
        matchedCustomer: customer,
        clearMatchedCustomer: customer == null,
        clearSubmission: true,
        message: customer == null ? null : 'Returning customer found',
      ),
    );
  }

  Future<VisitSubmissionResult> submit({
    required String name,
    required String mobileNumber,
    required String address,
    required Uint8List signaturePng,
  }) async {
    final current = state.valueOrNull ?? const KioskFormState();
    state = const AsyncLoading();

    try {
      final repository = ref.read(laundryRepositoryProvider);
      final signaturePath = await _saveSignature(signaturePng);

      final result = await repository.recordVisit(
        name: name,
        mobileNumber: mobileNumber,
        address: address,
        signatureImagePath: signaturePath,
      );

      state = AsyncData(
        current.copyWith(
          lastSubmission: result,
          matchedCustomer: result.customer,
          message: result.isNewCustomer
              ? 'New customer saved'
              : 'Visit added for returning customer',
        ),
      );

      return result;
    } catch (error, stackTrace) {
      state = AsyncData(
        current.copyWith(message: 'Could not save visit. Please try again.'),
      );
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncData(KioskFormState());
  }

  Future<String> _saveSignature(Uint8List signaturePng) async {
    if (kIsWeb) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'web-signature-$timestamp.png';
    }

    final docs = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(docs.path, 'signatures'));
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(p.join(directory.path, 'signature_$timestamp.png'));
    await file.writeAsBytes(signaturePng, flush: true);
    return file.path;
  }
}
