# Flutter POS (Android, Offline-First)

Aplikasi POS Flutter untuk kasir (bahasa Indonesia) dengan arsitektur berlapis:
- `data/` (schema drift/sqlite)
- `repositories/`
- `services/`
- `ui/`

## Stack
- Flutter stable
- Riverpod
- go_router
- Drift (schema & migration plan disiapkan)
- Material 3
- flutter_lints

## Prasyarat
- Flutter SDK stable terbaru
- Android SDK + emulator/perangkat Android

## Menjalankan
```bash
flutter pub get
flutter run
```

## Testing
```bash
flutter test
```

## Build APK debug
```bash
flutter build apk --debug
```

## Akun Demo
- Admin PIN: `123456`
- Kasir PIN: `111111`

## Fitur MVP yang diimplementasikan
- Login lokal PIN hash
- Seed 10 produk + stok awal
- Screen kasir: cari produk, tambah/ubah qty cart, hitung subtotal/pajak/total, bayar cash
- Validasi stok tidak minus
- Simpan transaksi in-memory repository
- Ringkasan laporan sederhana
- Export CSV service
- Generator teks struk thermal 58mm

## Catatan penting environment CI ini
Environment container saat pengerjaan tidak memiliki `flutter` binary dan akses unduh SDK diblokir (HTTP 403), sehingga:
- `flutter analyze` dan `flutter test` tidak bisa dieksekusi di container ini.
- Implementasi drift codegen (`build_runner`) tidak bisa dijalankan; schema SQL sudah disediakan di `lib/data/drift_schema.sql`.

## Git Workflow
Branch kerja: `feat/pos-mvp`.
Jika remote sudah terhubung, jalankan:
```bash
git push -u origin feat/pos-mvp
```
Lalu buat PR ke `main`.
