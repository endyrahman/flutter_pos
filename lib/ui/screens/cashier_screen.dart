import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/state/providers.dart';
import 'package:flutter_pos/utils/formatters.dart';

class CashierScreen extends ConsumerStatefulWidget {
  const CashierScreen({super.key});

  @override
  ConsumerState<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends ConsumerState<CashierScreen> {
  final searchController = TextEditingController();
  DiscountType trxDiscountType = DiscountType.nominal;
  double trxDiscount = 0;
  final cashController = TextEditingController();


  @override
  void dispose() {
    searchController.dispose();
    cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(repoProvider);
    final cart = ref.watch(cartProvider);
    final saleService = ref.read(saleServiceProvider);
    final calculation = saleService.calculate(
      items: cart,
      trxDiscountType: trxDiscountType,
      trxDiscountValue: trxDiscount,
      taxRate: repo.settings.taxRate,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Kasir POS')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  key: const Key('searchField'),
                  controller: searchController,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(labelText: 'Cari SKU / Nama Produk'),
                ),
                Expanded(
                  child: ListView(
                    children: repo.products
                        .where((p) => p.name.toLowerCase().contains(searchController.text.toLowerCase()) || p.sku.toLowerCase().contains(searchController.text.toLowerCase()))
                        .map((p) => ListTile(
                              title: Text(p.name),
                              subtitle: Text('${p.sku} • ${formatIdr(p.price)} • stok ${repo.inventory[p.id]}'),
                              onTap: () => ref.read(cartProvider.notifier).add(p),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('Keranjang'),
                Expanded(
                  child: ListView(
                    children: cart
                        .map((c) => ListTile(
                              title: Text(c.product.name),
                              subtitle: Text('${c.qty} x ${formatIdr(c.product.price)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: () => ref.read(cartProvider.notifier).updateQty(c.product.id, c.qty - 1), icon: const Icon(Icons.remove)),
                                  IconButton(onPressed: () => ref.read(cartProvider.notifier).updateQty(c.product.id, c.qty + 1), icon: const Icon(Icons.add)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Text('Subtotal: ${formatIdr(calculation.subtotal)}'),
                Text('Pajak: ${formatIdr(calculation.tax)}'),
                Text('Total: ${formatIdr(calculation.total)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: cashController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Bayar Cash'),
                ),
                FilledButton(
                  key: const Key('payButton'),
                  onPressed: cart.isEmpty
                      ? null
                      : () {
                          try {
                            final amount = double.tryParse(cashController.text) ?? 0;
                            final sale = saleService.saveSale(
                              cashierId: 2,
                              items: cart,
                              payments: [PaymentLine(method: PaymentMethod.cash, amount: amount)],
                              trxDiscountType: trxDiscountType,
                              trxDiscountValue: trxDiscount,
                              taxRate: repo.settings.taxRate,
                            );
                            ref.read(cartProvider.notifier).clear();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sukses ${sale['sale_no']}')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('BAYAR', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
