import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pos/main.dart';
import 'package:flutter_pos/repositories/pos_repository.dart';
import 'package:flutter_pos/services/auth_service.dart';
import 'package:flutter_pos/state/providers.dart';

void main() {
  testWidgets('Login screen tampil dengan input pin dan tombol masuk', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('pinField')), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Demo PIN: Admin 123456 • Kasir 111111'), findsOneWidget);
  });

  testWidgets('Admin tidak melihat menu POS di bottom navigation', (WidgetTester tester) async {
    final repo = PosRepository();
    final authService = AuthService(repo)..login('123456');
    final authController = AuthController(authService);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repoProvider.overrideWithValue(repo),
          authServiceProvider.overrideWithValue(authService),
          authControllerProvider.overrideWith((ref) => authController),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Transaksi'), findsOneWidget);
    expect(find.text('POS'), findsNothing);
  });
}
