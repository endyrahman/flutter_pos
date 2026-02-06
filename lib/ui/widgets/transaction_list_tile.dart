import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/formatters.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    required this.sale,
    required this.onTap,
    super.key,
  });

  final Map<String, dynamic> sale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(sale['sale_no'] as String),
        subtitle: Text(
          'Kasir #${sale['cashier_id']} • ${DateTime.parse(sale['created_at'] as String).toLocal()}',
        ),
        trailing: Text(
          formatIdr(sale['total'] as num),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
