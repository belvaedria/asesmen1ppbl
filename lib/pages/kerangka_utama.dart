import 'package:agriclima_lstm_707012400006/pages/halaman_prediksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import '../state/data_bloc.dart';
import '../state/target_provider.dart';
import '../state/theme_cubit.dart';
import 'halaman_beranda.dart';
import 'halaman_pengaturan.dart';
import 'halaman_statistik.dart';

class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}

class _KerangkaUtamaState extends State<KerangkaUtama> {
  // STATE LOKAL: hanya dipakai untuk mencatat indeks tab aktif di halaman ini
  int _indeksTerpilih = 0;

  // Daftar halaman tab yang dijaga tetap hidup oleh `IndexedStack`
  static const List<Widget> _halaman = [
    HalamanBeranda(),
    HalamanPrediksi(),
    HalamanStatistik(),
    HalamanPengaturan(),
  ];

  /// Membuka HalamanFormulir dengan Named Route, lalu menampilkan SnackBar
  /// jika halaman formulir mengirim balik nama item yang baru disimpan.
  Future<void> _bukaFormulirTambah() async {
    final hasil = await Navigator.pushNamed(context, AppRoutes.inputPrediksi);
    if (hasil is String && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Data "$hasil" berhasil ditambahkan!')),
        );
    }
  }

  /// Helper pembuat ikon dengan `Badge` angka kecil (pola `nusantara_cerdas_nav`)
  Widget _ikonDenganBadge({
    required IconData ikon,
    required int Function(DataState) ambilAngka,
  }) {
    return BlocSelector<DataBloc, DataState, int>(
      selector: ambilAngka,
      builder: (context, jumlah) {
        if (jumlah > 0) {
          return Badge(label: Text('$jumlah'), child: Icon(ikon));
        }
        return Icon(ikon);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final namaAplikasi = context.watch<TargetProvider>().namaAplikasi;

    return Scaffold(
      appBar: AppBar(
        title: Text(namaAplikasi),
        actions: [
          // Tombol `Switch` Mode Terang / Gelap langsung di AppBar (Kisi-kisi Bagian 5)
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              final sedangGelap = mode == ThemeMode.dark;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    sedangGelap ? Icons.dark_mode : Icons.light_mode,
                    size: 18,
                  ),
                  Switch(
                    value: sedangGelap,
                    onChanged: (nilaiBaru) {
                      context.read<ThemeCubit>().ubahModeGelap(nilaiBaru);
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // WAJIB SESUAI KISI-KISI: `IndexedStack` menjaga isi & posisi scroll tiap tab!
      body: IndexedStack(index: _indeksTerpilih, children: _halaman),

      // `FloatingActionButton` melayang untuk menambah data baru (Kisi-kisi Bagian 2)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormulirTambah,
        icon: const Icon(Icons.add),
        label: const Text('Prediksi Baru'),
      ),

      // `NavigationBar` di bagian bawah layar lengkap dengan `Badge`
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeksTerpilih,
        onDestinationSelected: (indeksBaru) {
          setState(() {
            _indeksTerpilih = indeksBaru;
          });
        },
        destinations: [
          NavigationDestination(
            icon: _ikonDenganBadge(
              ikon: Icons.list_alt_outlined,
              ambilAngka: (state) => state.jumlahBelumSelesai,
            ),
            selectedIcon: _ikonDenganBadge(
              ikon: Icons.list_alt,
              ambilAngka: (state) => state.jumlahBelumSelesai,
            ),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: _ikonDenganBadge(
              ikon: Icons.account_tree_outlined,
              ambilAngka: (state) => state.totalData,
            ),
            selectedIcon: _ikonDenganBadge(
              ikon: Icons.account_tree,
              ambilAngka: (state) => state.totalData,
            ),
            label: 'Prediksi',
          ),
          NavigationDestination(
            icon: _ikonDenganBadge(
              ikon: Icons.bar_chart_outlined,
              ambilAngka: (state) => state.totalData,
            ),
            selectedIcon: _ikonDenganBadge(
              ikon: Icons.bar_chart,
              ambilAngka: (state) => state.totalData,
            ),
            label: 'Statistik',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
