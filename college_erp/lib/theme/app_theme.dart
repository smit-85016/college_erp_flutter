import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1D9E75);
  static const Color primaryDark = Color(0xFF0F6E56);
  static const Color primaryLight = Color(0xFFE1F5EE);
  static const Color accent = Color(0xFF185FA5);
  static const Color warning = Color(0xFFEF9F27);
  static const Color danger = Color(0xFFE24B4A);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          background: surface,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(),
        scaffoldBackgroundColor: surface,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        cardTheme: CardTheme(
          color: cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: border, width: 0.8),
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.white,
          selectedIconTheme: const IconThemeData(color: primary),
          unselectedIconTheme: IconThemeData(color: textSecondary),
          selectedLabelTextStyle: GoogleFonts.nunito(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelTextStyle: GoogleFonts.nunito(color: textSecondary),
          indicatorColor: primaryLight,
        ),
      );
}
