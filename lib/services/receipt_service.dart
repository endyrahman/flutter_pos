import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/repositories/pos_repository.dart';

class ReceiptService {
  final PosRepository repo;
  ReceiptService(this.repo);

  String build58mmText(Map<String, dynamic> sale) {
    final b = StringBuffer();
    b.writeln(repo.settings.shopName);
    b.writeln(repo.settings.shopAddress);
    b.writeln('--------------------------------');
    b.writeln('No: ${sale['sale_no']}');
    b.writeln('Tanggal: ${sale['created_at']}');
    b.writeln('--------------------------------');
    final items = sale['items'] as List<CartItem>;
    for (final i in items) {
      b.writeln(i.product.name);
      b.writeln('${i.qty} x ${i.product.price} = ${i.net.toStringAsFixed(0)}');
    }
    b.writeln('--------------------------------');
    b.writeln('Subtotal : ${sale['subtotal']}');
    b.writeln('Diskon   : ${sale['discount_amount']}');
    b.writeln('Pajak    : ${sale['tax_amount']}');
    b.writeln('TOTAL    : ${sale['total']}');
    final payments = sale['payments'] as List<PaymentLine>;
    for (final p in payments) {
      b.writeln('Bayar ${p.method.name}: ${p.amount.toStringAsFixed(0)}');
    }
    b.writeln('Kembali  : ${sale['change_amount']}');
    b.writeln(repo.settings.receiptFooter);
    return b.toString();
  }
}
