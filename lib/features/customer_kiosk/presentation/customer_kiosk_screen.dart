import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';

import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/developer_contact_card.dart';
import '../../../core/widgets/exit_confirmation_scope.dart';
import '../../customers/data/laundry_repository.dart';
import '../../staff_auth/presentation/staff_pin_dialog.dart';
import '../application/kiosk_form_controller.dart';

class CustomerKioskScreen extends ConsumerStatefulWidget {
  const CustomerKioskScreen({super.key});

  @override
  ConsumerState<CustomerKioskScreen> createState() =>
      _CustomerKioskScreenState();
}

class _CustomerKioskScreenState extends ConsumerState<CustomerKioskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _signatureController = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Timer? _lookupDebounce;

  @override
  void dispose() {
    _lookupDebounce?.cancel();
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(kioskFormControllerProvider, (previous, next) {
      final customer = next.valueOrNull?.matchedCustomer;
      if (customer == null) return;
      if (_nameController.text != customer.name) {
        _nameController.text = customer.name;
      }
      if (_addressController.text != customer.address) {
        _addressController.text = customer.address;
      }
    });

    final formState = ref.watch(kioskFormControllerProvider);
    final today = shortDateFormat.format(DateTime.now());

    return ExitConfirmationScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laundry Customer Sign-in'),
          actions: [
            TextButton.icon(
              onPressed: () => _openStaffDashboard(context),
              icon: const Icon(Icons.dashboard_outlined),
              label: const Text('Staff'),
            ),
            const DeveloperAboutMenuButton(),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(today: today),
                      const SizedBox(height: 24),
                      _LargeTextField(
                        controller: _mobileController,
                        label: 'Mobile number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        onChanged: _scheduleMobileLookup,
                      ),
                      const SizedBox(height: 16),
                      _LargeTextField(
                        controller: _nameController,
                        label: 'Full name',
                        icon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      _LargeTextField(
                        controller: _addressController,
                        label: 'Address',
                        icon: Icons.home_outlined,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 20),
                      _SignatureBox(controller: _signatureController),
                      const SizedBox(height: 24),
                      if (formState.valueOrNull?.message != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            formState.valueOrNull!.message!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      FilledButton.icon(
                        onPressed: formState.isLoading ? null : _submit,
                        icon: formState.isLoading
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: const Text('Submit Visit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scheduleMobileLookup(String value) {
    _lookupDebounce?.cancel();
    _lookupDebounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(kioskFormControllerProvider.notifier).lookupMobile(value);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_signatureController.isEmpty) {
      _showSnack('Please add a signature before submitting.');
      return;
    }

    final signature = await _signatureController.toPngBytes();
    if (signature == null || signature.isEmpty) {
      _showSnack('Could not save the signature. Please try again.');
      return;
    }

    final result = await _submitVisit(signature);
    if (result == null) return;

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Visit Saved'),
          content: Text(
            result.availableFreeLoads > 0
                ? '${result.customer.name} is logged for today. This customer has a free load available. Staff can mark it redeemed when recording payment.'
                : '${result.customer.name} is logged for today. Staff can now add the number of laundry loads. Payment can be recorded when the customer returns.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    _clearForm();
  }

  Future<void> _openStaffDashboard(BuildContext context) async {
    final unlocked = await requestStaffAccess(context, ref);
    if (!unlocked || !context.mounted) return;
    context.push('/dashboard');
  }

  void _clearForm() {
    _nameController.clear();
    _mobileController.clear();
    _addressController.clear();
    _signatureController.clear();
    ref.read(kioskFormControllerProvider.notifier).reset();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<VisitSubmissionResult?> _submitVisit(Uint8List signature) async {
    try {
      return await ref
          .read(kioskFormControllerProvider.notifier)
          .submit(
            name: _nameController.text,
            mobileNumber: _mobileController.text,
            address: _addressController.text,
            signaturePng: signature,
          );
    } catch (_) {
      if (mounted) {
        _showSnack('Could not save visit. Please try again.');
      }
      return null;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.today});

  final String today;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.local_laundry_service_outlined, size: 48),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Visit Form',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Date: $today',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LargeTextField extends StatelessWidget {
  const _LargeTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 22,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}

class _SignatureBox extends StatelessWidget {
  const _SignatureBox({required this.controller});

  final SignatureController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Signature', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            TextButton.icon(
              onPressed: controller.clear,
              icon: const Icon(Icons.refresh),
              label: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 220,
            color: Colors.white,
            child: Signature(
              controller: controller,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
