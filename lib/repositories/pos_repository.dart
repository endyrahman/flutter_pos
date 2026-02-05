import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/utils/security.dart';

class PosRepository {
  ShopSettings settings = const ShopSettings(
    shopName: 'Toko Demo POS',
    shopAddress: 'Jl. Contoh No. 1',
    receiptFooter: 'Terima kasih sudah berbelanja',
    taxRate: 11,
  );

  final List<AppUser> users = [
    AppUser(id: 1, role: UserRole.admin, pinHash: hashPin('123456')),
    AppUser(id: 2, role: UserRole.kasir, pinHash: hashPin('111111')),
  ];

  final List<Category> categories = const [
    Category(id: 1, name: 'Makanan'),
    Category(id: 2, name: 'Minuman'),
  ];

  final List<Product> products = const [
    Product(id: 1, sku: 'SKU001', name: 'Beras 5kg', categoryId: 1, price: 78000, active: true),
    Product(id: 2, sku: 'SKU002', name: 'Minyak 1L', categoryId: 1, price: 19000, active: true),
    Product(id: 3, sku: 'SKU003', name: 'Gula 1kg', categoryId: 1, price: 16000, active: true),
    Product(id: 4, sku: 'SKU004', name: 'Kopi Sachet', categoryId: 2, price: 2500, active: true),
    Product(id: 5, sku: 'SKU005', name: 'Teh Celup', categoryId: 2, price: 9000, active: true),
    Product(id: 6, sku: 'SKU006', name: 'Susu UHT', categoryId: 2, price: 7000, active: true),
    Product(id: 7, sku: 'SKU007', name: 'Mie Instan', categoryId: 1, price: 3500, active: true),
    Product(id: 8, sku: 'SKU008', name: 'Sabun Mandi', categoryId: 1, price: 4500, active: true),
    Product(id: 9, sku: 'SKU009', name: 'Shampoo', categoryId: 1, price: 12000, active: true),
    Product(id: 10, sku: 'SKU010', name: 'Air Mineral', categoryId: 2, price: 4000, active: true),
  ];

  final Map<int, int> inventory = {for (var i = 1; i <= 10; i++) i: 20};

  final List<Map<String, dynamic>> sales = [];
  int _sequence = 0;

  String nextSaleNo(DateTime date) {
    _sequence++;
    final d = '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    return 'POS-$d-${_sequence.toString().padLeft(4, '0')}';
  }
}
