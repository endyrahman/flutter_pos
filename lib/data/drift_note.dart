/// Catatan implementasi Drift:
/// - Environment CI saat ini tidak memiliki Flutter SDK sehingga codegen drift
///   tidak bisa dieksekusi (`build_runner`).
/// - File `drift_schema.sql` sudah disiapkan sesuai tabel minimal MVP.
/// - Saat SDK tersedia, lanjutkan implementasi DAO + migration step di layer ini.
library;
