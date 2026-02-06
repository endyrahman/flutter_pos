import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/state/providers.dart';
import 'package:flutter_pos/ui/widgets/primary_button.dart';
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

    final filteredProducts = repo.products
        .where(
          (p) =>
              p.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
              p.sku.toLowerCase().contains(searchController.text.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('POS')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              key: const Key('searchField'),
              controller: searchController,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Cari SKU / Nama Produk',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text('Pilih Produk'),
                      children: [
                        for (final p in filteredProducts)
                          ListTile(
                            title: Text(p.name),
                            subtitle: Text('${p.sku} • ${formatIdr(p.price)} • stok ${repo.inventory[p.id]}'),
                            trailing: const Icon(Icons.add_circle_outline),
                            onTap: () => ref.read(cartProvider.notifier).add(p),
                          ),
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Keranjang', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          if (cart.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('Belum ada item.'),
                            ),
                          for (final c in cart)
                            ListTile(
                              dense: true,
                              title: Text(c.product.name),
                              subtitle: Text('${c.qty} x ${formatIdr(c.product.price)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => ref.read(cartProvider.notifier).updateQty(c.product.id, c.qty - 1),
                                    icon: const Icon(Icons.remove),
                                  ),
                                  IconButton(
                                    onPressed: () => ref.read(cartProvider.notifier).updateQty(c.product.id, c.qty + 1),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(),
                          Text('Subtotal: ${formatIdr(calculation.subtotal)}'),
                          Text('Pajak: ${formatIdr(calculation.tax)}'),
                          Text(
                            'Total: ${formatIdr(calculation.total)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: cashController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Bayar Cash'),
                          ),
                          const SizedBox(height: 8),
                          PrimaryButton(
                            key: const Key('payButton'),
                            label: 'Bayar',
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
                                      cashController.clear();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Sukses ${sale['sale_no']}')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
