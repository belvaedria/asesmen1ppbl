import 'package:agriclima_lstm_707012400006/main.dart';
import 'package:flutter/material.dart';


/// ============================================================================
/// CHEAT SHEET - TAB 1: HALAMAN BERANDA (`lib/pages/halaman_beranda.dart`)
/// Gabungan pola dari:
/// - `tugaspraktikum1/lib/panel_laporan.dart` (kartu ringkasan & status `if/else`)
/// - `kantin_campus_bloc/lib/pages/halaman_keranjang.dart` (`BlocBuilder` + olah List)
///
/// SESUAI KISI-KISI BAGIAN 1, 2, 3, & 5:
/// - Membedakan State Lokal (`_urutkanNilaiTertinggi` dengan `setState`) dan
///   State Global (`DataBloc` & `TargetProvider`).
/// - Menampilkan `LinearProgressIndicator` berdasarkan target dari `TargetProvider`.
/// - Menyaring (filter) List per kategori menggunakan `ChoiceChip`.
/// - Menampilkan data dinamis dengan `ListView.builder` & custom widget `KartuItem`.
/// - Berpindah ke `HalamanDetail` memakai `Navigator.push`.
/// - Konfirmasi hapus memakai `AlertDialog` + pemberitahuan `SnackBar`.
/// ============================================================================
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selamat Datang di Agriclima LSTM',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Aplikasi untuk mencatat hasil prediksi mikroklimat tanaman di laham Kelompok Tani Sri Mulya, agar kebutuhan penyiraman tiap petak mudah dipantau',
                  style: TextStyle(color: Colors.white, height: 1.4)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.assignment)),
            title: const Text('Model LSTM (Deep Learning)'),
            subtitle: const Text('Prediksi 24 jam ke depan dengan 3 parameter: suhu udara, kelembapan udara, kelembapan tanah'),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.tentang,
          ),
          icon: const Icon(Icons.add),
          label: const Text('Tentang Aplikasi'),
        ),
      ],
    );
  }
}