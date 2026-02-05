import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/repositories/pos_repository.dart';
import 'package:flutter_pos/services/inventory_service.dart';
import 'package:flutter_pos/services/sale_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SaleService menyimpan transaksi dan mengurangi stok', () {
    final repo = PosRepository();
    final inventory = InventoryService(repo);
    final saleService = SaleService(repo, inventory);

    final p = repo.products.first;
    final awal = repo.inventory[p.id]!;

    final sale = saleService.saveSale(
      cashierId: 2,
      items: [CartItem(product: p, qty: 2)],
      payments: const [PaymentLine(method: PaymentMethod.cash, amount: 200000)],
      trxDiscountType: DiscountType.nominal,
      trxDiscountValue: 0,
      taxRate: 11,
    );

    expect((sale['total'] as double) > 0, true);
    expect(repo.inventory[p.id], awal - 2);
    expect(repo.sales.length, 1);
  });
}
