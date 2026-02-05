import 'package:flutter_pos/repositories/pos_repository.dart';

class InventoryService {
  final PosRepository repo;
  InventoryService(this.repo);

  int stockOf(int productId) => repo.inventory[productId] ?? 0;

  void stockIn({required int productId, required int qty}) {
    repo.inventory[productId] = stockOf(productId) + qty;
  }

  void adjust({required int productId, required int delta}) {
    final next = stockOf(productId) + delta;
    if (next < 0) throw Exception('Stok tidak boleh minus');
    repo.inventory[productId] = next;
  }

  void reduceForSale(Map<int, int> soldQtyByProductId) {
    for (final entry in soldQtyByProductId.entries) {
      if (stockOf(entry.key) < entry.value) {
        throw Exception('Stok produk ID ${entry.key} tidak cukup');
      }
    }
    for (final entry in soldQtyByProductId.entries) {
      repo.inventory[entry.key] = stockOf(entry.key) - entry.value;
    }
  }
}
