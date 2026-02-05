import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/repositories/pos_repository.dart';
import 'package:flutter_pos/services/inventory_service.dart';

class SaleService {
  final PosRepository repo;
  final InventoryService inventoryService;
  SaleService(this.repo, this.inventoryService);

  SaleCalculation calculate({
    required List<CartItem> items,
    required DiscountType trxDiscountType,
    required double trxDiscountValue,
    required double taxRate,
  }) {
    final subtotal = items.fold<double>(0, (p, e) => p + e.gross);
    final itemDiscount = items.fold<double>(0, (p, e) => p + e.discountAmount);
    final afterItem = subtotal - itemDiscount;
    final trxDiscount = trxDiscountType == DiscountType.nominal
        ? trxDiscountValue
        : afterItem * (trxDiscountValue / 100);
    final dpp = afterItem - trxDiscount;
    final tax = dpp * (taxRate / 100);
    final total = (dpp + tax);
    return SaleCalculation(
      subtotal: subtotal,
      itemDiscount: itemDiscount,
      trxDiscount: trxDiscount,
      dpp: dpp,
      tax: tax,
      total: total,
    );
  }

  Map<String, dynamic> saveSale({
    required int cashierId,
    required List<CartItem> items,
    required List<PaymentLine> payments,
    required DiscountType trxDiscountType,
    required double trxDiscountValue,
    required double taxRate,
    String note = '',
  }) {
    if (items.isEmpty) throw Exception('Keranjang kosong');
    final soldMap = <int, int>{for (final i in items) i.product.id: i.qty};
    inventoryService.reduceForSale(soldMap);

    final calc = calculate(
      items: items,
      trxDiscountType: trxDiscountType,
      trxDiscountValue: trxDiscountValue,
      taxRate: taxRate,
    );
    final paidTotal = payments.fold<double>(0, (p, e) => p + e.amount);
    if (paidTotal < calc.total) throw Exception('Pembayaran kurang');

    final sale = {
      'sale_no': repo.nextSaleNo(DateTime.now()),
      'cashier_id': cashierId,
      'subtotal': calc.subtotal,
      'discount_amount': calc.itemDiscount + calc.trxDiscount,
      'tax_rate': taxRate,
      'tax_amount': calc.tax,
      'total': calc.total,
      'paid_total': paidTotal,
      'change_amount': paidTotal - calc.total,
      'note': note,
      'items': items,
      'payments': payments,
      'created_at': DateTime.now().toIso8601String(),
    };
    repo.sales.add(sale);
    return sale;
  }
}
