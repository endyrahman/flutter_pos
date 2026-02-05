import 'package:flutter_pos/ui/screens/cashier_screen.dart';
import 'package:flutter_pos/ui/screens/login_screen.dart';
import 'package:flutter_pos/ui/screens/report_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/kasir', builder: (_, __) => const CashierScreen()),
    GoRoute(path: '/laporan', builder: (_, __) => const ReportScreen()),
  ],
);
