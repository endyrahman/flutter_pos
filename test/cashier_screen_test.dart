import 'package:flutter/material.dart';
import 'package:flutter_pos/ui/screens/cashier_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cashier screen tampil dan tombol bayar ada', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CashierScreen()),
      ),
    );

    expect(find.byKey(const Key('searchField')), findsOneWidget);
    expect(find.byKey(const Key('payButton')), findsOneWidget);
  });
}
