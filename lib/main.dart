import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'pages/halaman_detail.dart';
import 'pages/halaman_formulir.dart';
import 'pages/kerangka_utama.dart';
import 'state/data_bloc.dart';
import 'state/target_provider.dart';
import 'state/theme_cubit.dart';

/// ============================================================================
/// CHEAT SHEET UTAMA - TITIK MASUK APLIKASI (`lib/main.dart`)
/// Menggabungkan pola persis dari praktikum-praktikum sebelumnya:
/// 1. `AppTheme`  -> dari `kantin_kampus_tema/lib/theme/app_theme.dart`
/// 2. `AppRoutes` -> dari `flutter_navigasi_707012400021` & `nusantara_cerdas_nav`
/// 3. State Global -> gabungan `ChangeNotifierProvider` (`state_interaksi`),
///    `ThemeCubit` (`kantin_kampus_tema`), dan `DataBloc` (`kantin_campus_bloc` +30 poin!)
/// ============================================================================

// =============================================================================
// 1. TEMA APLIKASI (Kisi-kisi Bagian 5 - Pola `kantin_kampus_tema`)
// Cukup ubah `seedColor` di bawah ini jika soal meminta warna dasar tertentu!
// =============================================================================
class AppTheme {
  static const Color seedColor = Colors.teal; // Cukup satu warna dasar

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(centerTitle: false),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: false),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

// =============================================================================
// 2. NAMED ROUTES (Kisi-kisi Bagian 1 - Pola `flutter_navigasi_707012400021`)
// Semua nama halaman dicatat rapi di satu tempat (`class AppRoutes`).
// =============================================================================
class AppRoutes {
  static const String beranda = '/';
  static const String tentang = '/tentang';
  static const String inputPrediksi = '/inputPrediksi';
  static const String detail = '/detail';

  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaUtama(),
      tentang: (context) => const HalamanTentang(),
      formulir: (context) => const HalamanFormulir(),
    };
  }

  /// Menangani perpindahan Named Route yang mengirim `arguments`
  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == detail) {
      final idItem = settings.arguments as String? ?? '';
      return MaterialPageRoute(
        builder: (context) => HalamanDetail(idItem: idItem),
      );
    }
    return null;
  }

  /// Pengaman jika memanggil nama route yang belum terdaftar
  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Route Tidak Ditemukan')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 56),
                const SizedBox(height: 12),
                Text(
                  'Halaman "${settings.name}" belum terdaftar di AppRoutes.',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const AplikasiAsesmen());
}

class AplikasiAsesmen extends StatelessWidget {
  const AplikasiAsesmen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pola `kantin_kampus_tema/lib/main.dart` + `state_interaksi/lib/main.dart`:
    // Membungkus root aplikasi dengan Provider, ThemeCubit, dan DataBloc (+30 poin)
    return ChangeNotifierProvider(
      create: (_) => TargetProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => DataBloc()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Template Asesmen Praktikum PPBL',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              initialRoute: AppRoutes.beranda,
              routes: AppRoutes.daftarRoute(),
              onGenerateRoute: AppRoutes.bentukRoute,
              onUnknownRoute: AppRoutes.routeTidakDikenal,
            );
          },
        ),
      ),
    );
  }
}
