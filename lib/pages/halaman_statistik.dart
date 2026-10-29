import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item_data.dart';
import '../state/data_bloc.dart';
import '../state/target_provider.dart';
import '../widgets/grafik_kategori.dart';

class HalamanStatistik extends StatefulWidget {
  const HalamanStatistik({super.key});

  @override
  State<HalamanStatistik> createState() => _HalamanStatistikState();
}

class _HalamanStatistikState extends State<HalamanStatistik> {
  // STATE LOKAL: pilih apakah grafik menampilkan Jumlah Data atau Total Nilai
  final bool _tampilkanTotalNilai = false;

  void _konfirmasiKosongkan(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Kosongkan Semua Data?'),
          content: const Text(
            'Seluruh data di daftar dan grafik batang akan direset menjadi 0.',
          ),
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
                context.read<DataBloc>().add(KosongkanData());
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua data telah dikosongkan')),
                );
              },
              child: const Text('Kosongkan'),
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
    final satuan = context.watch<TargetProvider>().satuanNilai;

    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        // Ambil `Map<String, int>` dari `DataState` sesuai mode yang dipilih
        final Map<String, int> dataGrafik = _tampilkanTotalNilai
            ? state.nilaiPerKategori
            : state.jumlahPerKategori;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. PANEL GENERATOR DATA ACAK (`Random` + `List.generate`)
              Card(
                margin: EdgeInsets.zero,
                color: skemaWarna.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generator Data Acak (Random & List.generate)',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: skemaWarna.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tekan tombol di bawah untuk menambah data acak dan lihat grafik batang langsung berubah!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: skemaWarna.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<DataBloc>().add(
                                BuatDataAcak(jumlah: 1),
                              );
                            },
                            icon: const Icon(Icons.casino_outlined, size: 18),
                            label: const Text('+1 Acak'),
                          ),
                          FilledButton.icon(
                            onPressed: () {
                              context.read<DataBloc>().add(
                                BuatDataAcak(jumlah: 5),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                      '5 data acak berhasil dibuat dengan List.generate()!',
                                    ),
                                  ),
                                );
                            },
                            icon: const Icon(Icons.auto_awesome, size: 18),
                            label: const Text('+5 Acak (List.generate)'),
                          ),
                          if (state.totalData > 0)
                            OutlinedButton.icon(
                              onPressed: () => _konfirmasiKosongkan(context),
                              icon: const Icon(Icons.delete_sweep_outlined),
                              label: const Text('Kosongkan'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. KARTU GRAFIK BATANG (`BarChart` fl_chart)
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jumlah Prediksi per Status Mikroklimat',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GrafikKategori(
                        dataPerKategori: dataGrafik,
                        satuanSumbuY: _tampilkanTotalNilai ? satuan : 'data',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
