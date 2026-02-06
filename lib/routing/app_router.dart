import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/state/providers.dart';
import 'package:flutter_pos/ui/screens/cashier_screen.dart';
import 'package:flutter_pos/ui/screens/login_screen.dart';
import 'package:flutter_pos/ui/screens/transactions/transactions_screen.dart';
import 'package:flutter_pos/ui/widgets/app_shell_scaffold.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.read(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: auth,
    redirect: (context, state) {
      final user = auth.session;
      final loggedIn = user != null;
      final inLogin = state.matchedLocation == '/login';

      if (!loggedIn) return inLogin ? null : '/login';
      if (inLogin) {
        return user.role == UserRole.admin ? '/transaksi' : '/pos';
      }

      if (user.role == UserRole.admin && state.matchedLocation.startsWith('/pos')) {
        return '/transaksi';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (_, state, child) => Consumer(
          builder: (context, ref, _) {
            final role = ref.watch(authControllerProvider).session?.role ?? UserRole.kasir;
            return AppShellScaffold(
              currentLocation: state.matchedLocation,
              role: role,
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(path: '/pos', builder: (_, __) => const CashierScreen()),
          GoRoute(path: '/transaksi', builder: (_, __) => const TransactionsScreen()),
        ],
      ),
    ],
  );
});
