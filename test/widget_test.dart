import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_loyalty_program/app.dart';

void main() {
  testWidgets('shows kiosk form on launch', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LaundryLoyaltyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Laundry Customer Sign-in'), findsOneWidget);
    expect(find.text('Submit Visit'), findsOneWidget);
    expect(find.text('Designed & Developed by RHK'), findsNothing);

    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('Designed & Developed by RHK'), findsOneWidget);
    expect(find.text('Scan to message on Viber'), findsOneWidget);
    expect(find.text('Email: rkuhonta@gmail.com'), findsOneWidget);
  });
}
