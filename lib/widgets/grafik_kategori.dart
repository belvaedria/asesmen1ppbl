import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrafikKategori extends StatelessWidget {
  const GrafikKategori({
    super.key,
    required this.dataPerKategori,
    required this.satuanSumbuY,
  });

  final Map<String, int> dataPerKategori;
  final String satuanSumbuY;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skemaWarna = theme.colorScheme;

    // Mengubah pasangan kunci-nilai Map menjadi List agar punya urutan indeks X (0, 1, 2, ...)
    final daftarEntri = dataPerKategori.entries.toList();

    // Menentukan batas atas sumbu Y agar batang tertinggi tidak mentok ke atas
    final nilaiTertinggi = daftarEntri.isEmpty
        ? 0
        : daftarEntri.map((e) => e.value).reduce(max);
    final double batasAtasY = nilaiTertinggi <= 4
        ? 5.0
        : (nilaiTertinggi * 1.25).ceilToDouble();

    return SizedBox(
      height: 230,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 12, left: 4),
        child: BarChart(
          BarChartData(
            maxY: batasAtasY,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: skemaWarna.outlineVariant.withValues(alpha: 0.5),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: skemaWarna.outlineVariant),
                left: BorderSide(color: skemaWarna.outlineVariant),
              ),
            ),
            // Tooltip saat batang diketuk
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final namaTanaman = daftarEntri[group.x].key;
                  return BarTooltipItem(
                    '$namaTanaman\n${rod.toY.toInt()} $satuanSumbuY',
                    TextStyle(
                      color: skemaWarna.onInverseSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            // Pengaturan judul sumbu X (nama kategori) & sumbu Y (angka)
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  getTitlesWidget: (value, meta) {
                    if (value % 1 != 0) return const SizedBox.shrink();
                    return Text(
                      value.toInt().toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: skemaWarna.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    final indeks = value.toInt();
                    if (indeks < 0 || indeks >= daftarEntri.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        daftarEntri[indeks].key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: skemaWarna.onSurface,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Pola `statistik_page.dart`: menyusun `barGroups` dari nilai kategori
            barGroups: List.generate(daftarEntri.length, (indeks) {
              final entri = daftarEntri[indeks];
              return BarChartGroupData(
                x: indeks,
                barRods: [
                  BarChartRodData(
                    toY: entri.value.toDouble(),
                    width: 24,
                    color: skemaWarna.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
