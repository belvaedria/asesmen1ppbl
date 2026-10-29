import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item_data.dart';
import '../state/data_bloc.dart';
import '../state/target_provider.dart';

/// ============================================================================
/// CHEAT SHEET - HALAMAN DETAIL (`lib/pages/halaman_detail.dart`)
/// Pola persis dari:
/// - `flutter_navigasi_707012400021/lib/pages/halaman_detail.dart`
/// - `nusantara_cerdas_nav_707012400021/lib/pages/detail_layanan_page.dart`
///
/// SESUAI KISI-KISI BAGIAN 1, 2, & 5:
/// - Bisa dibuka lewat `Navigator.push` langsung ATAU lewat `Navigator.pushNamed`
///   dengan mengirim `arguments` ke `AppRoutes.detail`!
/// - Kembali ke halaman sebelumnya memakai `Navigator.pop(context)`.
/// - Menampilkan hasil getter `if/else` dan `switch` dari `ItemData`.
/// ============================================================================
class HalamanDetail extends StatelessWidget {
  const HalamanDetail({super.key, required this.idItem});

  final String idItem;

  void _konfirmasiHapus(BuildContext context, ItemData item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Data Ini?'),
          content: Text('Yakin ingin menghapus "${item.nama}"?'),
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
                Navigator.pop(dialogContext); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman daftar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data "${item.nama}" dihapus')),
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
    final satuan = context.watch<TargetProvider>().satuanNilai;

    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        final cocok = state.daftarItem
            .where((item) => item.id == idItem)
            .toList();

        if (cocok.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Rincian Data')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Data tidak ditemukan atau sudah dihapus.'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            ),
          );
        }

        final item = cocok.first;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Rincian Data'),
            actions: [
              IconButton(
                tooltip: 'Hapus data',
                icon: Icon(Icons.delete_outline, color: skemaWarna.error),
                onPressed: () => _konfirmasiHapus(context, item),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  color: skemaWarna.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              item.ikonStatus,
                              color: skemaWarna.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.labelStatus,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: skemaWarna.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Badge(
                              backgroundColor: item.warnaStatus,
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  'Status ${item.labelStatus}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.petugas,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: skemaWarna.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${item.suhu}°C',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: skemaWarna.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hasil Getter Logika Model',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<DataBloc>().add(UbahStatusSelesai(item.id));
                  },
                  icon: Icon(
                    item.selesai ? Icons.replay : Icons.check_circle_outline,
                  ),
                  label: Text(
                    item.selesai
                        ? 'Ubah Menjadi Belum Selesai'
                        : 'Tandai Sudah Selesai',
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali (Navigator.pop)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BarisInfo extends StatelessWidget {
  const _BarisInfo({required this.label, required this.isi});

  final String label;
  final String isi;

  @override
  Widget build(BuildContext context) {
    final skemaWarna = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: skemaWarna.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              isi,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: skemaWarna.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
