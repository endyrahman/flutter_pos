enum UserRole { admin, kasir }
enum PaymentMethod { cash, qris, debit }
enum DiscountType { nominal, percent }

class ShopSettings {
  final String shopName;
  final String shopAddress;
  final String receiptFooter;
  final double taxRate;
  const ShopSettings({
    required this.shopName,
    required this.shopAddress,
    required this.receiptFooter,
    required this.taxRate,
  });
}

class AppUser {
  final int id;
  final UserRole role;
  final String pinHash;
  const AppUser({required this.id, required this.role, required this.pinHash});
}

class Category {
  final int id;
  final String name;
  const Category({required this.id, required this.name});
}

class Product {
  final int id;
  final String sku;
  final String? barcode;
  final String name;
  final int? categoryId;
  final int price;
  final bool active;
  const Product({
    required this.id,
    required this.sku,
    this.barcode,
    required this.name,
    this.categoryId,
    required this.price,
    required this.active,
  });
}

class CartItem {
  final Product product;
  final int qty;
  final DiscountType discountType;
  final double discountValue;
  const CartItem({
    required this.product,
    required this.qty,
    this.discountType = DiscountType.nominal,
    this.discountValue = 0,
  });

  int get gross => product.price * qty;
  double get discountAmount => discountType == DiscountType.nominal
      ? discountValue
      : gross * (discountValue / 100);
  double get net => gross - discountAmount;

  CartItem copyWith({
    int? qty,
    DiscountType? discountType,
    double? discountValue,
  }) {
    return CartItem(
      product: product,
      qty: qty ?? this.qty,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
    );
  }
}

class PaymentLine {
  final PaymentMethod method;
  final double amount;
  const PaymentLine({required this.method, required this.amount});
}

class SaleCalculation {
  final double subtotal;
  final double itemDiscount;
  final double trxDiscount;
  final double dpp;
  final double tax;
  final double total;
  const SaleCalculation({
    required this.subtotal,
    required this.itemDiscount,
    required this.trxDiscount,
    required this.dpp,
    required this.tax,
    required this.total,
  });
}
