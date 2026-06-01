import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../customers/application/laundry_repository_provider.dart';
import '../application/staff_auth_provider.dart';

Future<bool> requestStaffAccess(BuildContext context, WidgetRef ref) async {
  final repository = ref.read(laundryRepositoryProvider);
  final hasPin = await repository.hasStaffPin();
  if (!context.mounted) return false;

  final unlocked = hasPin
      ? await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _VerifyStaffPinDialog(),
        )
      : await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _CreateStaffPinDialog(),
        );

  final isUnlocked = unlocked ?? false;
  if (isUnlocked) {
    ref.read(staffSessionUnlockedProvider.notifier).state = true;
  }
  return isUnlocked;
}

class _CreateStaffPinDialog extends ConsumerStatefulWidget {
  const _CreateStaffPinDialog();

  @override
  ConsumerState<_CreateStaffPinDialog> createState() =>
      _CreateStaffPinDialogState();
}

class _CreateStaffPinDialogState extends ConsumerState<_CreateStaffPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Staff PIN'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Set a 6-digit PIN for staff-only screens.'),
            const SizedBox(height: 16),
            _PinField(controller: _pinController, label: 'New PIN'),
            const SizedBox(height: 12),
            _PinField(
              controller: _confirmPinController,
              label: 'Confirm PIN',
              validator: (value) {
                final baseError = _validateSixDigitPin(value);
                if (baseError != null) return baseError;
                if (value != _pinController.text) {
                  return 'PINs do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _savePin, child: const Text('Save PIN')),
      ],
    );
  }

  Future<void> _savePin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(laundryRepositoryProvider).setStaffPin(_pinController.text);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _VerifyStaffPinDialog extends ConsumerStatefulWidget {
  const _VerifyStaffPinDialog();

  @override
  ConsumerState<_VerifyStaffPinDialog> createState() =>
      _VerifyStaffPinDialogState();
}

class _VerifyStaffPinDialogState extends ConsumerState<_VerifyStaffPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Staff PIN'),
      content: Form(
        key: _formKey,
        child: _PinField(
          controller: _pinController,
          label: 'Enter PIN',
          errorText: _errorText,
          onChanged: (_) {
            if (_errorText == null) return;
            setState(() => _errorText = null);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _verifyPin, child: const Text('Unlock')),
      ],
    );
  }

  Future<void> _verifyPin() async {
    if (!_formKey.currentState!.validate()) return;

    final isValid = await ref
        .read(laundryRepositoryProvider)
        .verifyStaffPin(_pinController.text);
    if (!mounted) return;
    if (!isValid) {
      setState(() => _errorText = 'Incorrect PIN');
      return;
    }
    Navigator.of(context).pop(true);
  }
}

class _PinField extends StatelessWidget {
  const _PinField({
    required this.controller,
    required this.label,
    this.errorText,
    this.onChanged,
    this.validator = _validateSixDigitPin,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        errorText: errorText,
        counterText: '',
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

String? _validateSixDigitPin(String? value) {
  final pin = value ?? '';
  if (pin.length != 6) {
    return 'Enter a 6-digit PIN';
  }
  return null;
}
