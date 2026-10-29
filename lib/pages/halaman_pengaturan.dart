import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import '../state/data_bloc.dart';
import '../state/target_provider.dart';
import '../state/theme_cubit.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skemaWarna = theme.colorScheme;
    final targetProvider = context.watch<TargetProvider>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        // 1. KARTU TEMA APLIKASI (`ThemeCubit` + `Switch` - Kisi-kisi Bagian 5)
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            final sedangGelap = mode == ThemeMode.dark;
            return Card(
              margin: EdgeInsets.zero,
              child: SwitchListTile(
                secondary: Icon(
                  sedangGelap ? Icons.dark_mode : Icons.light_mode,
                  color: skemaWarna.primary,
                ),
                title: const Text(
                  'Mode Gelap (Dark Mode)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  sedangGelap
                      ? 'Aktif (ThemeMode.dark dari ThemeCubit)'
                      : 'Nonaktif (ThemeMode.light dari ThemeCubit)',
                ),
                value: sedangGelap,
                onChanged: (nilaiBaru) {
                  context.read<ThemeCubit>().ubahModeGelap(nilaiBaru);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 14),

        // 2. KARTU TARGET & PRESET TOPIK PRAKTIKUM (`TargetProvider`)
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target & Simulasi Studi Kasus (Provider)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Menggunakan ChangeNotifier + notifyListeners() seperti di state_interaksi & form_pendaftaran.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: skemaWarna.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Target Jumlah Data:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: () =>
                          context.read<TargetProvider>().kurangiTarget(),
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '${targetProvider.targetData}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: () =>
                          context.read<TargetProvider>().tambahTarget(),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const Divider(height: 24),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('Portal Kampus (Poin)'),
                      onPressed: () =>
                          context.read<TargetProvider>().terapkanPreset(
                            namaAplikasiBaru: 'Portal Kampus Terpadu',
                            satuanBaru: 'Poin',
                            targetBaru: 10,
                          ),
                    ),
                    ActionChip(
                      label: const Text('Kantin Kampus (Rb)'),
                      onPressed: () =>
                          context.read<TargetProvider>().terapkanPreset(
                            namaAplikasiBaru: 'Kantin Kampus',
                            satuanBaru: 'Rb',
                            targetBaru: 12,
                          ),
                    ),
                    ActionChip(
                      label: const Text('Nusantara Cerdas (Skor)'),
                      onPressed: () =>
                          context.read<TargetProvider>().terapkanPreset(
                            namaAplikasiBaru: 'Nusantara Cerdas',
                            satuanBaru: 'Skor',
                            targetBaru: 8,
                          ),
                    ),
                    ActionChip(
                      label: const Text('Kegiatan Kampus (Kuota)'),
                      onPressed: () =>
                          context.read<TargetProvider>().terapkanPreset(
                            namaAplikasiBaru: 'Pendaftaran Kegiatan',
                            satuanBaru: 'Kuota',
                            targetBaru: 15,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 3. DEMO NAMED ROUTE DENGAN ARGUMENTS & ROUTE SALAH (Pola `flutter_navigasi`)
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uji Navigasi Named Route (Pola Praktikum Navigasi)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        final daftar = context
                            .read<DataBloc>()
                            .state
                            .daftarItem;
                        if (daftar.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tambahkan minimal 1 data dulu'),
                            ),
                          );
                          return;
                        }
                        Navigator.pushNamed(
                          context,
                          AppRoutes.detail,
                          arguments: daftar.first.id,
                        );
                      },
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Detail Item #1 (Named Route)'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/route-belum-ada');
                      },
                      icon: const Icon(Icons.warning_amber_rounded, size: 18),
                      label: const Text('Uji Route Salah'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 4. PETA HUBUNGAN KE PRAKTIKUM SEBELUMNYA (CHEAT SHEET IN-APP)
        Card(
          margin: EdgeInsets.zero,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Peta Kode Berdasarkan Praktikum Kamu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ExpansionTile(
                  leading: Icon(Icons.looks_one_outlined),
                  title: Text('Praktikum 1: Widget Dasar & Custom Card'),
                  childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(
                      'Asal: praktikum1 & tugaspraktikum1 (ProfilCard, KartuPilar, PanelLaporanWarga).\n'
                      'Di sini: lib/widgets/kartu_ringkasan.dart, lib/widgets/kartu_item.dart, dan getter if/else di lib/models/item_data.dart.',
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.looks_two_outlined),
                  title: Text('Praktikum 2: AppRoutes, IndexedStack & Badge'),
                  childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(
                      'Asal: flutter_navigasi_707012400021 & nusantara_cerdas_nav_707012400021.\n'
                      'Di sini: class AppRoutes (daftarRoute, bentukRoute, routeTidakDikenal) di main.dart, serta KerangkaUtama (IndexedStack + NavigationBar + Badge).',
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.looks_3_outlined),
                  title: Text('Praktikum 3: setState vs Provider'),
                  childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(
                      'Asal: state_interaksi_707012400021 (HalamanSetState & KeranjangModel).\n'
                      'Di sini: _indeksTerpilih & filter urutan memakai setState(); TargetProvider memakai ChangeNotifier + notifyListeners().',
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.looks_4_outlined),
                  title: Text('Praktikum 4: Formulir & BarChart fl_chart'),
                  childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(
                      'Asal: form_pendaftaran_707012400021 (FormulirPage & StatistikPage).\n'
                      'Di sini: HalamanFormulir (TextEditingController + dispose, Dropdown, Radio, Checkbox, formLengkap, FAB reset) & HalamanStatistik (Random, List.generate, Map, BarChart).',
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.looks_5_outlined),
                  title: Text('Praktikum 5 & 6: BLoC (+30 Poin) & Tema'),
                  childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(
                      'Asal: kantin_campus_bloc & kantin_kampus_tema.\n'
                      'Di sini: DataBloc (TambahData, HapusData, UbahStatusSelesai, BuatDataAcak) + AppTheme (ColorScheme.fromSeed) + ThemeCubit (Switch Dark Mode).',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
