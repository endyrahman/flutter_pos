import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pos/main.dart';

void main() {
  testWidgets('Aplikasi membuka halaman login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Login POS'), findsOneWidget);
    expect(find.byKey(const Key('pinField')), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
