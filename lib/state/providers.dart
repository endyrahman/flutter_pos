import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/repositories/pos_repository.dart';
import 'package:flutter_pos/services/auth_service.dart';
import 'package:flutter_pos/services/inventory_service.dart';
import 'package:flutter_pos/services/report_service.dart';
import 'package:flutter_pos/services/sale_service.dart';

final repoProvider = Provider((ref) => PosRepository());
final authServiceProvider = Provider((ref) => AuthService(ref.read(repoProvider)));
final inventoryServiceProvider = Provider((ref) => InventoryService(ref.read(repoProvider)));
final saleServiceProvider = Provider(
  (ref) => SaleService(ref.read(repoProvider), ref.read(inventoryServiceProvider)),
);
final reportServiceProvider = Provider((ref) => ReportService(ref.read(repoProvider)));

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  void add(Product product) {
    final idx = state.indexWhere((e) => e.product.id == product.id);
    if (idx >= 0) {
      final copy = [...state];
      copy[idx] = copy[idx].copyWith(qty: copy[idx].qty + 1);
      state = copy;
    } else {
      state = [...state, CartItem(product: product, qty: 1)];
    }
  }

  void updateQty(int productId, int qty) {
    state = [
      for (final item in state)
        if (item.product.id == productId) item.copyWith(qty: qty) else item,
    ].where((e) => e.qty > 0).toList();
  }

  void clear() => state = const [];
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());
