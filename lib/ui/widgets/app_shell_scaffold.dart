import 'package:flutter/material.dart';
import 'package:flutter_pos/models/models.dart';
import 'package:go_router/go_router.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    required this.child,
    required this.role,
    required this.currentLocation,
    super.key,
  });

  final Widget child;
  final UserRole role;
  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    final destinations = <_MenuItem>[
      if (role == UserRole.kasir) const _MenuItem(label: 'POS', icon: Icons.point_of_sale, location: '/pos'),
      const _MenuItem(label: 'Transaksi', icon: Icons.receipt_long, location: '/transaksi'),
    ];

    final currentIndex = destinations.indexWhere((e) => currentLocation.startsWith(e.location));

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (index) {
          final target = destinations[index].location;
          if (target != currentLocation) context.go(target);
        },
        destinations: [
          for (final item in destinations)
            NavigationDestination(icon: Icon(item.icon), label: item.label),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.label, required this.icon, required this.location});

  final String label;
  final IconData icon;
  final String location;
}
