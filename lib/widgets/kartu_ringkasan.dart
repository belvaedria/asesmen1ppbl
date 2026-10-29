import 'package:flutter/material.dart';

/// ============================================================================
/// CHEAT SHEET - CUSTOM WIDGET #1 (`lib/widgets/kartu_ringkasan.dart`)
/// Gabungan pola dari:
/// - `praktikum1/lib/profil_card.dart` & `tugaspraktikum1/lib/kartu_pilar.dart`
/// - `kantin_kampus_tema/lib/widgets/cart_summary_bar.dart` (`Theme.of(context)`)
///
/// SESUAI KISI-KISI BAGIAN 1 & BAGIAN 5:
/// - `StatelessWidget` buatan sendiri yang bisa dipakai berulang kali lewat parameter.
/// - Mengambil warna dari `Theme.of(context)` agar teks jelas di mode terang & gelap.
/// - Menggunakan `Expanded` di dalam `Row` agar bebas dari error overflow!
/// ============================================================================
class KartuRingkasan extends StatelessWidget {
  const KartuRingkasan({
    super.key,
    required this.judul,
    required this.nilaiUtama,
    required this.keterangan,
    required this.ikon,
    this.warnaAksen,
  });

  final String judul;
  final String nilaiUtama;
  final String keterangan;
  final IconData ikon;
  final Color? warnaAksen;

  @override
  Widget build(BuildContext context) {
    // Pola `kantin_kampus_tema`: selalu ambil tema aktif dengan `Theme.of(context)`
    final theme = Theme.of(context);
    final warna = warnaAksen ?? theme.colorScheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(ikon, color: warna, size: 22),
                const SizedBox(width: 8),
                // `Expanded` wajib di dalam `Row` supaya teks panjang tidak overflow
                Expanded(
                  child: Text(
                    judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              nilaiUtama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              keterangan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

