import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item_data.dart';
import '../state/data_bloc.dart';
import '../state/target_provider.dart';

class HalamanFormulir extends StatefulWidget {
  const HalamanFormulir({super.key});

  @override
  State<HalamanFormulir> createState() => _HalamanFormulirState();
}

class _HalamanFormulirState extends State<HalamanFormulir> {
  // 1. Controller kotak teks (pola `FormulirPage`)
  final namaController = TextEditingController();
  final nilaiController = TextEditingController();

  // 2. State lokal pilihan form
  String tanamanTerpilih = ItemData.daftarTanaman.first;
  String petakTerpilih = ItemData.daftarPetak.first;
  bool sudahSelesai = false;

  // Penanda apakah pengguna sudah mengetik (supaya pesan merah tidak muncul saat baru dibuka)
  bool _namaDisentuh = false;
  bool _nilaiDisentuh = false;

  // 3. WAJIB: Bersihkan controller di `dispose()` agar memori tidak boros!
  @override
  void dispose() {
    namaController.dispose();
    nilaiController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // LOGIKA VALIDASI ISIAN PENGGUNA (`if / else`)
  // ===========================================================================

  /// Memeriksa kotak teks Nama: tidak boleh kosong
  String? get errorNama {
    final teks = namaController.text.trim();
    if (teks.isEmpty) {
      return 'Nama / judul tidak boleh kosong';
    } else if (teks.length < 3) {
      return 'Nama minimal 3 huruf';
    }
    return null;
  }

  /// Memeriksa kotak teks Nilai: wajib berupa angka bulat > 0
  String? get errorNilai {
    final teks = nilaiController.text.trim();
    if (teks.isEmpty) {
      return 'Nilai angka tidak boleh kosong';
    }
    final angka = int.tryParse(teks);
    if (angka == null) {
      return 'Isian harus berupa angka bulat (contoh: 50)';
    } else if (angka <= 0) {
      return 'Angka harus lebih dari 0';
    }
    return null;
  }

  /// Pola `bool get formLengkap` persis di `FormulirPage` (`form_pendaftaran`)
  bool get formLengkap => errorNama == null && errorNilai == null;

  void _bersihkanFormulir() {
    setState(() {
      namaController.clear();
      nilaiController.clear();
      tanamanTerpilih = ItemData.daftarTanaman.first;
      petakTerpilih = ItemData.daftarPetak.first;
      sudahSelesai = false;
      _namaDisentuh = false;
      _nilaiDisentuh = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulir berhasil dibersihkan')),
    );
  }

  void _simpanFormulir() {
    if (!formLengkap) return;

    final itemBaru = ItemData(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      petugas: namaController.text.trim(),
      suhu: nilaiController.text.trim(),
      udara: nilaiController.text.trim(),
      tanah: nilaiController.text.trim(),
      tanaman: tanamanTerpilih,
      petak: petakTerpilih,
      selesai: sudahSelesai,
    );

    // Kirim Event `TambahData` ke `DataBloc` (+30 poin BLoC!)
    context.read<DataBloc>().add(TambahData(itemBaru));

    // Tutup halaman & kirim balik nama item ke `KerangkaUtama` (pola praktikum navigasi)
    Navigator.pop(context, itemBaru.petak);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final satuan = context.watch<TargetProvider>().satuanNilai;

    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Tambah Data')),

      // `FloatingActionButton` reset formulir (pola `FormulirPage` di praktikum 4)
      floatingActionButton: FloatingActionButton(
        onPressed: _bersihkanFormulir,
        tooltip: 'Bersihkan formulir',
        child: const Icon(Icons.refresh),
      ),

      // `SingleChildScrollView` mencegah overflow saat keyboard muncul di layar
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 4. RADIOLISTTILE (PILIH SATU PRIORITAS)
            // Catatan: Flutter 3.32+ memakai `RadioGroup`. Jika komputer lab kampus
            // memakai versi lama, pindahkan `groupValue` & `onChanged` ke dalam
            // `RadioListTile` seperti di `form_pendaftaran/lib/pages/formulir_page.dart`.
            Text(
              'Petak',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              child: RadioGroup<String>(
                groupValue: petakTerpilih,
                onChanged: (nilai) {
                  if (nilai != null) {
                    setState(() => petakTerpilih = nilai);
                  }
                },
                child: Column(
                  children: ItemData.daftarPetak.map((petak) {
                    return RadioListTile<String>(
                      title: Text('Petak $petak'),
                      value: petak,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 3. DROPDOWNBUTTONFORMFIELD (DAFTAR PILIHAN KATEGORI)
            DropdownButtonFormField<String>(
              initialValue: tanamanTerpilih,
              decoration: const InputDecoration(
                labelText: 'Nama Tanaman',
                border: OutlineInputBorder(),
              ),
              items: ItemData.daftarTanaman.map((tanaman) {
                return DropdownMenuItem<String>(
                  value: tanaman,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(tanaman),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (nilaiBaru) {
                if (nilaiBaru != null) {
                  setState(() => tanamanTerpilih = nilaiBaru);
                }
              },
            ),
            const SizedBox(height: 18),

            // 1. TEXTFIELD NAMA / JUDUL
            TextField(
              controller: namaController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Prediksi Suhu Udara (°C)',
                border: const OutlineInputBorder(),
                errorText: _namaDisentuh ? errorNama : null,
              ),
              onChanged: (_) {
                setState(() => _namaDisentuh = true);
              },
            ),
            const SizedBox(height: 14),

            // 2. TEXTFIELD ANGKA (WAJIB ANGKA)
            TextField(
              controller: nilaiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Prediksi Kelembapan Udara (%)',
                suffixText: satuan,
                border: const OutlineInputBorder(),
                errorText: _nilaiDisentuh ? errorNilai : null,
              ),
              onChanged: (_) {
                setState(() => _nilaiDisentuh = true);
              },
            ),
            const SizedBox(height: 14),

            // 2. TEXTFIELD ANGKA (WAJIB ANGKA)
            TextField(
              controller: nilaiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Prediksi Kelembapan Tanah (%)',
                suffixText: satuan,
                border: const OutlineInputBorder(),
                errorText: _nilaiDisentuh ? errorNilai : null,
              ),
              onChanged: (_) {
                setState(() => _nilaiDisentuh = true);
              },
            ),
            const SizedBox(height: 14),

            // 2. TEXTFIELD ANGKA (WAJIB ANGKA)
            TextField(
              controller: nilaiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nama Petugas',
                suffixText: satuan,
                border: const OutlineInputBorder(),
                errorText: _nilaiDisentuh ? errorNilai : null,
              ),
              onChanged: (_) {
                setState(() => _nilaiDisentuh = true);
              },
            ),
            const SizedBox(height: 14),

            // 5. CHECKBOXLISTTILE (CENTANG STATUS SELESAI)
            Card(
              margin: EdgeInsets.zero,
              child: CheckboxListTile(
                value: sudahSelesai,
                title: const Text('Data sudah benar'),
                onChanged: (nilai) {
                  setState(() {
                    sudahSelesai = nilai ?? false;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // 6. TOMBOL SIMPAN AKTIF / NONAKTIF SESUAI KONDISI (Pola `FormulirPage`)
            ElevatedButton.icon(
              onPressed: formLengkap ? _simpanFormulir : null,
              icon: const Icon(Icons.save_outlined),
              label: Text(
                formLengkap
                    ? 'Simpan Data'
                    : 'Isi Nama & Angka dengan Benar untuk Menyimpan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

