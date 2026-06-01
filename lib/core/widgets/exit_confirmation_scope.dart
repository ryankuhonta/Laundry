import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationScope extends StatelessWidget {
  const ExitConfirmationScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final canReturnToPreviousScreen = Navigator.of(context).canPop();

    return PopScope(
      canPop: canReturnToPreviousScreen,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit App?'),
              content: const Text('Are you sure you want to close the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Exit'),
                ),
              ],
            );
          },
        );

        if (shouldExit == true && context.mounted) {
          await SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
