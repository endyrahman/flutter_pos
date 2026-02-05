import 'package:flutter_pos/repositories/pos_repository.dart';

class ReportSummary {
  final double omzet;
  final int transaksi;
  final double totalDiskon;
  final double totalPajak;
  const ReportSummary({
    required this.omzet,
    required this.transaksi,
    required this.totalDiskon,
    required this.totalPajak,
  });
}

class ReportService {
  final PosRepository repo;
  ReportService(this.repo);

  ReportSummary summarize() {
    final omzet = repo.sales.fold<double>(0, (p, e) => p + (e['total'] as double));
    final diskon = repo.sales.fold<double>(0, (p, e) => p + (e['discount_amount'] as double));
    final pajak = repo.sales.fold<double>(0, (p, e) => p + (e['tax_amount'] as double));
    return ReportSummary(
      omzet: omzet,
      transaksi: repo.sales.length,
      totalDiskon: diskon,
      totalPajak: pajak,
    );
  }
}
