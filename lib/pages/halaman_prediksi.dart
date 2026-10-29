import 'package:agriclima_lstm_707012400006/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item_data.dart';
import '../state/data_bloc.dart';
import '../state/target_provider.dart';
import '../widgets/kartu_item.dart';
import '../widgets/kartu_ringkasan.dart';
import 'halaman_detail.dart';

class HalamanPrediksi extends StatefulWidget {
  const HalamanPrediksi({super.key});

  @override
  State<HalamanPrediksi> createState() => _HalamanPrediksiState();
}

class _HalamanPrediksiState extends State<HalamanPrediksi> {
  // STATE LOKAL: hanya mengatur urutan tampilan di halaman Beranda ini saja
  bool _urutkanNilaiTertinggi = false;

  /// Menampilkan `AlertDialog` konfirmasi sebelum menghapus item (Kisi-kisi Bagian 2)
  void _konfirmasiHapus(BuildContext context, ItemData item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Data?'),
          content: Text('Yakin ingin menghapus "${item.petak}" dari daftar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                context.read<DataBloc>().add(HapusData(item.id));
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Data "${item.petak}" dihapus')),
                  );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skemaWarna = theme.colorScheme;

    // 1. Baca State Global dari Provider (`ChangeNotifier`)
    final targetProvider = context.watch<TargetProvider>();

    // 2. Baca State Global dari BLoC (`BlocBuilder`)
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        final progres = targetProvider.hitungProgres(state.totalData);

        final pilihanFilter = ['Semua', ...ItemData.daftarTanaman];

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // B. DUA CUSTOM WIDGET `KartuRingkasan` DI DALAM `Row` + `Expanded`
              Row(
                children: [
                  Expanded(
                    child: KartuRingkasan(
                      judul: ' ',
                      nilaiUtama: '${state.totalNilai}',
                      keterangan: 'total',
                      ikon: Icons.calculate_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KartuRingkasan(
                      judul: ' ',
                      nilaiUtama: '${state.jumlahSelesai}/${state.totalData}',
                      keterangan: 'optimal',
                      ikon: Icons.task_alt,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KartuRingkasan(
                      judul: ' ',
                      nilaiUtama: '${state.jumlahSelesai}/${state.totalData}',
                      keterangan: 'perlu tindakan',
                      ikon: Icons.task_alt,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // C. FILTER KATEGORI (`UbahFilterKategori`) + URUTAN LOKAL (`setState`)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Daftar Data',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _urutkanNilaiTertinggi = !_urutkanNilaiTertinggi;
                      });
                    },
                    icon: Icon(
                      _urutkanNilaiTertinggi
                          ? Icons.trending_down
                          : Icons.schedule,
                      size: 18,
                    ),
                    label: Text(
                      _urutkanNilaiTertinggi ? 'Nilai Tertinggi' : 'Terbaru',
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: pilihanFilter.map((tanaman) {
                    final dipilih = state.tanamanTerpilih == tanaman;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tanaman),
                        selected: dipilih,
                        onSelected: (_) {
                          context.read<DataBloc>().add(
                            UbahFilterKategori(tanaman),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // D. DAFTAR DATA DINAMIS DENGAN `ListView.builder`
              if (daftarTampil.isEmpty)
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: skemaWarna.outline,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Belum ada data untuk tanaman "${state.tanamanTerpilih}".',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daftarTampil.length,
                  itemBuilder: (context, index) {
                    final item = daftarTampil[index];
                    return KartuItem(
                      item: item,
                      satuan: targetProvider.satuanNilai,
                      // Pindah halaman dengan `Navigator.push` (Kisi-kisi Bagian 1)
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HalamanDetail(idItem: item.id),
                          ),
                        );
                      },
                      onUbahSelesai: () {
                        context.read<DataBloc>().add(
                          UbahStatusSelesai(item.id),
                        );
                      },
                      onHapus: () => _konfirmasiHapus(context, item),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
