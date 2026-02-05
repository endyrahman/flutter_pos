import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_pos/repositories/pos_repository.dart';

class ExportService {
  final PosRepository repo;
  ExportService(this.repo);

  Future<File> exportSalesCsv(String path) async {
    final rows = <List<dynamic>>[
      ['sale_no', 'cashier_id', 'subtotal', 'discount', 'tax', 'total', 'paid', 'change', 'created_at'],
      ...repo.sales.map((s) => [
            s['sale_no'],
            s['cashier_id'],
            s['subtotal'],
            s['discount_amount'],
            s['tax_amount'],
            s['total'],
            s['paid_total'],
            s['change_amount'],
            s['created_at'],
          ]),
    ];
    final content = const ListToCsvConverter().convert(rows);
    final file = File(path);
    return file.writeAsString(content);
  }
}
