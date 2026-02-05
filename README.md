# Flutter POS (Android, Offline-First)

Aplikasi POS Flutter (bahasa Indonesia) untuk kasir dengan stack:
- Riverpod
- go_router
- Drift (SQLite)
- Material 3

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

## Fitur MVP yang tersedia
- Login lokal berbasis PIN hash + role admin/kasir
- Seed 10 produk + stok awal
- Kasir: cari produk (autofocus), tambah item, ubah qty, hitung subtotal/pajak/total, bayar
- Validasi stok tidak boleh minus
- Simpan transaksi + nomor transaksi harian
- Laporan ringkas
- Export CSV
- Generator struk teks thermal 58mm

## Konflik PR (README.md, lib/main.dart, pubspec.yaml)
Jika PR menampilkan konflik di tiga file ini, selesaikan dengan memilih versi branch `feat/pos-mvp` (fitur POS penuh), lalu jalankan:
```bash
git checkout feat/pos-mvp
git fetch origin
# jika main berubah
git merge origin/main
# resolve konflik, lalu
git add README.md lib/main.dart pubspec.yaml
git commit -m "chore: resolve merge conflicts with main"
git push origin feat/pos-mvp
```

## Catatan environment container ini
Container ini tidak memiliki binary `flutter` dan akses unduh Flutter SDK diblokir, sehingga `flutter analyze` dan `flutter test` tidak bisa dijalankan di sini.
