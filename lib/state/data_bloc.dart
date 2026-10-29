import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item_data.dart';

abstract class DataEvent {}

class TambahData extends DataEvent {
  TambahData(this.item);
  final ItemData item;
}

class HapusData extends DataEvent {
  HapusData(this.id);
  final String id;
}

class UbahStatusSelesai extends DataEvent {
  UbahStatusSelesai(this.id);
  final String id;
}

class UbahFilterKategori extends DataEvent {
  UbahFilterKategori(this.kategori);
  final String kategori;
}

class BuatDataAcak extends DataEvent {
  BuatDataAcak({this.jumlah = 5});
  final int jumlah;
}

class KosongkanData extends DataEvent {}

// =============================================================================
// 2. STATE: Data yang disimpan & ditampilkan ke layar lewat `BlocBuilder`
// =============================================================================
class DataState {
  const DataState({required this.daftarItem, this.tanamanTerpilih = 'Semua'});

  final List<ItemData> daftarItem;
  final String tanamanTerpilih;

  /// MENYARING (FILTER) LIST berdasarkan kategori aktif (Kisi-kisi Bagian 3)
  List<ItemData> get daftarTersaring {
    if (tanamanTerpilih == 'Semua') {
      return daftarItem;
    }
    return daftarItem
        .where((item) => item.tanaman == tanamanTerpilih)
        .toList();
  }

  /// MENGHITUNG JUMLAH DATA di dalam List (Kisi-kisi Bagian 3)
  int get totalData => daftarItem.length;

  Map<String, int> get jumlahPerTanaman {
    final Map<String, int> hasil = {
      for (final tanaman in ItemData.daftarTanaman) tanaman: 0,
    };
    for (final item in daftarItem) {
      hasil[item.tanaman] = (hasil[item.tanaman] ?? 0) + 1;
    }
    return hasil;
  }

  /// MENGHITUNG TOTAL NILAI PER KATEGORI DENGAN `Map`
  /// Dipakai jika soal meminta grafik batang berdasarkan nominal/harga/skor!
  Map<String, int> get nilaiPerKategori {
    final Map<String, int> hasil = {
      for (final tanaman in ItemData.daftarTanaman) tanaman: 0,
    };
    for (final item in daftarItem) {
      hasil[item.tanaman] = (hasil[item.tanaman] ?? 0) + item.nilai;
    }
    return hasil;
  }

  DataState copyWith({List<ItemData>? daftarItem, String? tanamanTerpilih}) {
    return DataState(
      daftarItem: daftarItem ?? this.daftarItem,
      tanamanTerpilih: tanamanTerpilih ?? this.tanamanTerpilih,
    );
  }
}

// =============================================================================
// 3. BLOC: Menerima Event, mengolah List, lalu mengeluarkan State baru (`emit`)
// =============================================================================
class DataBloc extends Bloc<DataEvent, DataState> {
  final Random _acak = Random();

  DataBloc() : super(DataState(daftarItem: _dataAwalContoh())) {
    // A. Menambah 1 item baru ke List (pola `List.from` persis praktikum BLoC)
    on<TambahData>((event, emit) {
      final daftar = List<ItemData>.from(state.daftarItem);
      daftar.insert(0, event.item);
      emit(state.copyWith(daftarItem: daftar));
    });

    // B. Menghapus item dari List berdasarkan ID
    on<HapusData>((event, emit) {
      final daftar = state.daftarItem
          .where((item) => item.id != event.id)
          .toList();
      emit(state.copyWith(daftarItem: daftar));
    });

    // C. Mengubah centang selesai / belum selesai
    on<UbahStatusSelesai>((event, emit) {
      final daftar = List<ItemData>.from(state.daftarItem);
      final indeks = daftar.indexWhere((item) => item.id == event.id);
      if (indeks == -1) return;

      daftar[indeks] = daftar[indeks].copyWith(
        selesai: !daftar[indeks].selesai,
      );
      emit(state.copyWith(daftarItem: daftar));
    });

    // D. Mengubah filter kategori
    on<UbahFilterKategori>((event, emit) {
      emit(state.copyWith(tanamanTerpilih: event.tanaman));
    });

    // E. Membuat banyak data acak sekaligus (`Random` + `List.generate`)
    // Sesuai Kisi-kisi Bagian 4!
    on<BuatDataAcak>((event, emit) {
      const contohNama = [
        'Jurnal Praktikum PPBL',
        'Pesanan Nasi Goreng',
        'Pengajuan Surat Aktif',
        'Seminar Kota Cerdas',
        'Pesanan Es Teh Manis',
        'Laporan Fasilitas Lab',
        'Workshop Flutter',
        'Tugas Basis Data',
      ];

      // Menghasilkan `event.jumlah` data sekaligus dengan `List.generate`
      final dataBaru = List.generate(event.jumlah, (indeks) {
        final petugasAcak = contohPetugas[_acak.nextInt(contohPetugas.length)];
        final tanamanAcak = ItemData
            .daftarTanaman[_acak.nextInt(ItemData.daftarTanaman.length)];
        final petakAcak = ItemData
            .daftarPetak[_acak.nextInt(ItemData.daftarPetak.length)];
        final suhuAcak = _acak.nextInt(91) + 10; // Angka acak 10 s/d 100
        final tanahAcak = _acak.nextInt(91) + 10; // Angka acak 10 s/d 100
        final udaraAcak = _acak.nextInt(91) + 10; // Angka acak 10 s/d 100
        final selesaiAcak = _acak.nextBool();

        return ItemData(
          id: '${DateTime.now().microsecondsSinceEpoch}_$indeks',
          petugas: '$petugasAcak #${_acak.nextInt(90) + 10}',
          suhu: suhuAcak,
          tanah: tanahAcak,
          udara: udaraAcak,
          tanaman: tanamanAcak,
          petak: petakAcak,
          selesai: selesaiAcak,
        );
      });

        return ItemData(
          id: '${DateTime.now().microsecondsSinceEpoch}_$indeks',
          petugas: '$petugasAcak #${_acak.nextInt(90) + 10}',
          suhu: suhuAcak,
          tanah: tanahAcak,
          udara: udaraAcak,
          tanaman: tanamanAcak,
          petak: petakAcak,
          selesai: selesaiAcak,
        );
      });

      final daftar = [...dataBaru, ...state.daftarItem];
      emit(state.copyWith(daftarItem: daftar));
    });

    // F. Mengosongkan seluruh isi List
    on<KosongkanData>((event, emit) {
      emit(state.copyWith(daftarItem: const []));
    });
  }
