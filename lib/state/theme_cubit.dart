import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ============================================================================
/// CHEAT SHEET - CUBIT TEMA (`lib/state/theme_cubit.dart`)
/// Pola persis dari praktikum `kantin_kampus_tema/lib/cubit/theme_cubit.dart`!
///
/// SESUAI KISI-KISI BAGIAN 3 & BAGIAN 5:
/// - Cubit menyimpan data sebagai state (`ThemeMode`) dan mengubahnya dengan `emit()`.
/// - Ditampilkan di `main.dart` dan halaman menggunakan `BlocBuilder<ThemeCubit, ThemeMode>`.
/// - Dihubungkan ke tombol `Switch` untuk mengganti mode terang & mode gelap.
///
/// CARA PAKAI DI UI:
/// - Baca apakah sedang gelap : `final gelap = context.watch<ThemeCubit>().state == ThemeMode.dark;`
/// - Ubah lewat Switch        : `context.read<ThemeCubit>().ubahModeGelap(nilaiBaru);`
/// ============================================================================
class ThemeCubit extends Cubit<ThemeMode> {
  // Default awal: Mode Terang (ThemeMode.light)
  ThemeCubit() : super(ThemeMode.light);

  /// Dipakai oleh tombol `Switch(value: ..., onChanged: ...)` (Kisi-kisi Bagian 5)
  void ubahModeGelap(bool aktifGelap) {
    emit(aktifGelap ? ThemeMode.dark : ThemeMode.light);
  }

  /// Dipakai jika ingin tombol ikon bolak-balik seperti di `kantin_kampus_tema`
  void toggle() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}

