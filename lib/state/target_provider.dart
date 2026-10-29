import 'package:flutter/foundation.dart';

/// ============================================================================
/// CHEAT SHEET - PROVIDER / CHANGENOTIFIER (`lib/state/target_provider.dart`)
/// Pola persis dari praktikum:
/// - `state_interaksi_707012400021/lib/models/keranjang_model.dart`
/// - `form_pendaftaran_707012400021/lib/model/pendaftar_model.dart`
///
/// SESUAI KISI-KISI BAGIAN 3:
/// - Menyimpan data dengan `ChangeNotifier`.
/// - Memberi tahu tampilan saat data berubah memakai `notifyListeners()`.
///
/// CARA PAKAI DI UI:
/// - Membaca & memantau perubahan : `final target = context.watch<TargetProvider>();`
/// - Memanggil aksi di tombol     : `context.read<TargetProvider>().tambahTarget();`
/// ============================================================================
class TargetProvider extends ChangeNotifier {
  int _targetData = 10;
  String _namaAplikasi = 'Portal Kampus Terpadu';
  String _satuanNilai = 'Poin';

  // GETTER
  int get targetData => _targetData;
  String get namaAplikasi => _namaAplikasi;
  String get satuanNilai => _satuanNilai;

  /// Menghitung nilai progres (0.0 sampai 1.0) untuk `LinearProgressIndicator`
  double hitungProgres(int jumlahSaatIni) {
    if (_targetData <= 0) return 0.0;
    return (jumlahSaatIni / _targetData).clamp(0.0, 1.0);
  }

  /// Logika `if / else` seperti di `tugaspraktikum1/lib/panel_laporan.dart`
  String statusTarget(int jumlahSaatIni) {
    if (jumlahSaatIni == 0) {
      return 'Belum ada data tercatat. Tambahkan data baru melalui tombol +.';
    } else if (jumlahSaatIni < _targetData) {
      final sisa = _targetData - jumlahSaatIni;
      return 'Kurang $sisa data lagi untuk mencapai target ($_targetData data).';
    } else {
      return 'Target $_targetData data telah tercapai!';
    }
  }

  void tambahTarget() {
    _targetData++;
    notifyListeners(); // Memberi tahu UI agar gambar ulang
  }

  void kurangiTarget() {
    if (_targetData <= 1) return;
    _targetData--;
    notifyListeners();
  }

  /// Simulasi ganti skenario studi kasus secara instan dari tab Pengaturan
  void terapkanPreset({
    required String namaAplikasiBaru,
    required String satuanBaru,
    required int targetBaru,
  }) {
    _namaAplikasi = namaAplikasiBaru;
    _satuanNilai = satuanBaru;
    if (targetBaru >= 1) {
      _targetData = targetBaru;
    }
    notifyListeners();
  }
}

