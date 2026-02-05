import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pos/state/providers.dart';
import 'package:flutter_pos/utils/formatters.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.read(reportServiceProvider).summarize();
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Omzet: ${formatIdr(s.omzet)}'),
            Text('Transaksi: ${s.transaksi}'),
            Text('Total Diskon: ${formatIdr(s.totalDiskon)}'),
            Text('Total Pajak: ${formatIdr(s.totalPajak)}'),
          ],
        ),
      ),
    );
  }
}
