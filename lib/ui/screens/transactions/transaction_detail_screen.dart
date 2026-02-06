import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/state/providers.dart';
import 'package:flutter_pos/ui/widgets/primary_button.dart';
import 'package:flutter_pos/utils/formatters.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({required this.sale, super.key});

  final Map<String, dynamic> sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = sale['items'] as List<CartItem>;
    return Scaffold(
      appBar: AppBar(title: Text('Detail ${sale['sale_no']}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${sale['created_at']}'),
            const SizedBox(height: 12),
            const Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  for (final item in items)
                    ListTile(
                      dense: true,
                      title: Text(item.product.name),
                      subtitle: Text('${item.qty} x ${formatIdr(item.product.price)}'),
                      trailing: Text(formatIdr(item.net)),
                    ),
                ],
              ),
            ),
            Text('Total: ${formatIdr(sale['total'] as num)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Reprint Struk',
              onPressed: () {
                final text = ref.read(receiptServiceProvider).build58mmText(sale);
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Preview Struk'),
                    content: SingleChildScrollView(child: Text(text)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
