import 'package:flutter/material.dart';

@immutable
class ItemData {
  const ItemData({
    required this.id,
    required this.suhu,
    required this.udara,
    required this.tanah,
    required this.petak,
    required this.tanaman,
    required this.petugas,
    this.selesai = false,
  });

  // 1. PROPERTI
  final String id;
  final String suhu; 
  final String udara; 
  final String tanah;
  final String petak;
  final String tanaman; // Input dari DropdownButtonFormField
  final String petugas; // Input dari TextFormField
  final bool selesai; // Input dari CheckboxListTile

  static const List<String> daftarTanaman = [
    'Padi',
    'Jagung',
    'Cabai',
  ];

  String get labelStatus {
    if (tanah < 40) {
      return 'Kering';
    } else if (tanah >= 40 && tanah < 70) {
      return 'Optimal';
    } else if (tanah >= 70) {
      return 'Terlalu Lembap';
    } else {
      return 'Tidak Valid';
    }
  }

  static const List<String> daftarPetak = ['Petak 1', 'Petak 2'];

  static const Map<String, String> catatanPerawatan = {
    'Padi': 'Jaga genangan air 2-5 cm pada fase vegetatik dan keringkan lahan menjelang panen',
    'Jagung': 'Siram saat tanah mulai kering dan hindari genangan di sekitar perakaran',
    'Cabai': 'Gunakan mulsa untuk menjaga kelembapan tanah dan siram pada pagi atau sore hari',
  };

  Color get warnaStatus {
    switch (labelStatus) {
      case 'Kering':
        return Colors.red;
      case 'Terlalu Lembap':
        return Colors.orange;
      case 'Optimal':
      default:
        return Colors.green;
    }
  }

  static const Map<String, IconData> ikonStatus = {
    'Kering': Icons.sunny,
    'Terlalu Lembap': Icons.water_drop,
    'Optimal': Icons.check_circle,
  };

  ItemData copyWith({required bool selesai}) {}
}