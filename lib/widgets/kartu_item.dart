import 'package:flutter/material.dart';

import '../models/item_data.dart';

class KartuItem extends StatelessWidget {
  const KartuItem({
    super.key,
    required this.item,
    required this.satuan,
    required this.onTap,
    required this.onUbahSelesai,
    required this.onHapus,
  });

  final ItemData item;
  final String satuan;
  final VoidCallback onTap;
  final VoidCallback onUbahSelesai;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skemaWarna = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              // 1. Kotak centang status selesai
              Checkbox(value: item.selesai, onChanged: (_) => onUbahSelesai()),

              // 2. Kolom nama & kategori (dibungkus `Expanded` agar anti-overflow!)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: item.selesai
                            ? skemaWarna.onSurfaceVariant
                            : skemaWarna.onSurface,
                        decoration: item.selesai
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(item.ikon, size: 15, color: skemaWarna.primary),
                        const SizedBox(width: 4),
                        // `Flexible` menjaga teks kategori tidak menabrak label prioritas
                        Flexible(
                          child: Text(
                            item.kategori,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: skemaWarna.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: item.warnaPrioritas.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.prioritas,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: item.warnaPrioritas,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // 3. Nilai angka & tombol hapus
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.nilai} $satuan',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: skemaWarna.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.kategoriNilai, // Getter `if/else` dari ItemData
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: skemaWarna.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              IconButton(
                tooltip: 'Hapus data',
                icon: Icon(Icons.delete_outline, color: skemaWarna.error),
                onPressed: onHapus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
