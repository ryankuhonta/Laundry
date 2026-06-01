import 'package:flutter/material.dart';

class DeveloperContactCard extends StatelessWidget {
  const DeveloperContactCard({super.key, this.qrSize = 220});

  static const String viberNumber = '0917 448 2425';
  static const String email = 'rkuhonta@gmail.com';

  final double qrSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _VCardQrCode(size: qrSize),
            const SizedBox(height: 14),
            Text(
              'Designed & Developed by RHK',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scan to message on Viber',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Viber: $viberNumber',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            Text(
              'Email: $email',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperAboutMenuButton extends StatelessWidget {
  const DeveloperAboutMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_DeveloperMenuAction>(
      tooltip: 'More options',
      onSelected: (value) {
        switch (value) {
          case _DeveloperMenuAction.about:
            showDeveloperAboutDialog(context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _DeveloperMenuAction.about,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.info_outline),
            title: Text('About'),
          ),
        ),
      ],
    );
  }
}

Future<void> showDeveloperAboutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('About'),
        content: const SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: DeveloperContactCard(qrSize: 220),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

enum _DeveloperMenuAction { about }

class _VCardQrCode extends StatelessWidget {
  const _VCardQrCode({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'QR code for RHK app support contact card',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CustomPaint(
            size: Size.square(size),
            painter: const _QrPainter(_vCardQrRows),
          ),
        ),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter(this.rows);

  final List<String> rows;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..isAntiAlias = false;
    final moduleSize = size.shortestSide / rows.length;

    for (var row = 0; row < rows.length; row++) {
      for (var col = 0; col < rows[row].length; col++) {
        if (rows[row][col] != '1') continue;
        canvas.drawRect(
          Rect.fromLTWH(
            col * moduleSize,
            row * moduleSize,
            moduleSize,
            moduleSize,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) {
    return oldDelegate.rows != rows;
  }
}

const _vCardQrRows = [
  '11111110100000011010101111111',
  '10000010111010110000101000001',
  '10111010000011110000001011101',
  '10111010111100000110101011101',
  '10111010000011000111101011101',
  '10000010011010100111101000001',
  '11111110101010101010101111111',
  '00000000100011101100000000000',
  '10110111000111100101001001011',
  '11101101110010000001001011011',
  '11010011100000100000011101110',
  '00101101111001111011110100000',
  '00011111010010011111100101110',
  '00010101010101010011101000101',
  '00110110111000101001010101111',
  '00011100000001011001011010000',
  '00100011100110001000010111001',
  '00111000110001011010110101100',
  '10101010110100010010100010100',
  '00101100111000010110010110101',
  '01011110011011000101111111111',
  '00000000101111100000100011101',
  '11111110101001000011101011010',
  '10000010101010001010100011010',
  '10111010010110101110111110110',
  '10111010101001110110010111001',
  '10111010101001001011000100101',
  '10000010000010011010101101010',
  '11111110101011101001110100010',
];
