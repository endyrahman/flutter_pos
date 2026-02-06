import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pos/state/providers.dart';
import 'package:flutter_pos/ui/screens/transactions/transaction_detail_screen.dart';
import 'package:flutter_pos/ui/widgets/transaction_list_tile.dart';

enum DateFilter { today, week, all }

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final searchController = TextEditingController();
  DateFilter selectedFilter = DateFilter.today;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool _includeByDate(DateTime date) {
    final now = DateTime.now();
    final local = date.toLocal();
    switch (selectedFilter) {
      case DateFilter.today:
        return now.year == local.year && now.month == local.month && now.day == local.day;
      case DateFilter.week:
        return now.difference(local).inDays <= 7;
      case DateFilter.all:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sales = ref.read(repoProvider).sales;
    final keyword = searchController.text.trim().toLowerCase();
    final filtered = sales.where((sale) {
      final saleNo = (sale['sale_no'] as String).toLowerCase();
      final createdAt = DateTime.tryParse(sale['created_at'] as String) ?? DateTime.now();
      final byKeyword = keyword.isEmpty || saleNo.contains(keyword);
      final byDate = _includeByDate(createdAt);
      return byKeyword && byDate;
    }).toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              key: const Key('searchSaleNoField'),
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Cari nomor transaksi',
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Hari ini'),
                  selected: selectedFilter == DateFilter.today,
                  onSelected: (_) => setState(() => selectedFilter = DateFilter.today),
                ),
                ChoiceChip(
                  label: const Text('Minggu ini'),
                  selected: selectedFilter == DateFilter.week,
                  onSelected: (_) => setState(() => selectedFilter = DateFilter.week),
                ),
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: selectedFilter == DateFilter.all,
                  onSelected: (_) => setState(() => selectedFilter = DateFilter.all),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('Belum ada transaksi sesuai filter.'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final sale = filtered[index];
                        return TransactionListTile(
                          sale: sale,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TransactionDetailScreen(sale: sale),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
