# flutter_pos

Aplikasi Point of Sale (POS) sederhana berbasis Flutter dengan state Riverpod dan routing `go_router`.

## Menjalankan

```bash
flutter pub get
flutter run
```

## Flow Login & Role

- Login menggunakan PIN 6 digit.
- PIN demo:
  - Admin: `123456`
  - Kasir: `111111`
- Hak akses menu:
  - **Admin**: hanya menu **Transaksi**.
  - **Kasir**: menu **POS** dan **Transaksi**.

## Menu

1. **POS**
   - Input transaksi, tambah item, proses pembayaran cash.
2. **Transaksi**
   - Daftar transaksi terbayar.
   - Cari berdasarkan `sale_no`.
   - Filter cepat: hari ini / minggu ini / semua.
   - Detail transaksi + tombol **Reprint Struk** (preview text).
