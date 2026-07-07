// ==============================================================================
// Yoga24X AI Engineering OS — World-Class Luxury AI Wellness Platform Theme
// Embodying Apple, Oura Ring, WHOOP, Calm, Headspace & Superhuman Aesthetics
// ==============================================================================

import 'package:flutter/material.dart';

class AppTheme {
  // ── Curated Luxury Color Tokens (Alo Yoga, Aman Sanctuary, Calm) ────────────
  // Primary: Deep Organic Sage — deeply calming, rooted in nature and prana.
  static const Color primary = Color(0xFF385E4D); // Deep Organic Sage
  static const Color secondary = Color(0xFF5A8A70); // Soft Botanical Sage
  static const Color accent = Color(0xFFC5A059); // Ethereal Sanctuary Gold
  
  static const Color bgLight = Color(0xFFF7F5F0); // Warm Organic Sand / Oat
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure Altar White
  
  static const Color bgDark = Color(0xFF0E1110); // Deep Luxury Forest Obsidian
  static const Color surfaceDark = Color(0xFF161B19); // Elevated Glass Slate
  static const Color borderDark = Color(0xFF242C29); // Subtle Botanical Border
  
  static const Color textPrimaryLight = Color(0xFF1B2420); // Deep Charcoal Forest
  static const Color textSecondaryLight = Color(0xFF6A7872); // Muted Botanist Grey
  
  static const Color textPrimaryDark = Color(0xFFF2F5F3); // Soft Pearl White
  static const Color textSecondaryDark = Color(0xFF8E9E96); // Muted Sage Grey
  
  static const Color success = Color(0xFF488A68); // Calming Botanical Green
  static const Color meditation = Color(0xFF5D7A8C); // Serene Lake Blue-Grey
  static const Color breathing = Color(0xFF6CA0A6); // Ethereal River Blue

  // ── Light Theme Definition (Warm Ivory & Deep Forest Green) ─────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        tertiary: meditation,
        surface: surfaceLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: bgLight,
      fontFamily: 'Inter',
      textTheme: _buildTextTheme(textPrimaryLight, textSecondaryLight),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimaryLight),
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          color: textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shadowColor: textPrimaryLight.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: textPrimaryLight.withValues(alpha: 0.04), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: textSecondaryLight.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: textSecondaryLight.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondaryLight, fontFamily: 'Inter'),
      ),
    );
  }

  // ── Dark Theme Definition (Deep Luxury Obsidian & Emerald) ──────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: secondary,
        primary: secondary,
        secondary: accent,
        tertiary: meditation,
        surface: surfaceDark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: bgDark,
      fontFamily: 'Inter',
      textTheme: _buildTextTheme(textPrimaryDark, textSecondaryDark),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimaryDark),
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          color: textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: borderDark, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: secondary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1E29),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: secondary, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondaryDark, fontFamily: 'Inter'),
      ),
    );
  }

  // ── Apple-Level Typography Engine ───────────────────────────────────────────
  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: TextStyle(fontFamily: 'Outfit', fontSize: 36, fontWeight: FontWeight.w700, color: primaryColor, letterSpacing: -1.0, height: 1.2),
      displayMedium: TextStyle(fontFamily: 'Outfit', fontSize: 30, fontWeight: FontWeight.w700, color: primaryColor, letterSpacing: -0.8, height: 1.25),
      displaySmall: TextStyle(fontFamily: 'Outfit', fontSize: 24, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: -0.6, height: 1.3),
      headlineLarge: TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w700, color: primaryColor, letterSpacing: -0.5, height: 1.3),
      headlineMedium: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: -0.4, height: 1.35),
      headlineSmall: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: -0.3, height: 1.4),
      titleLarge: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: -0.2),
      titleMedium: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600, color: primaryColor),
      titleSmall: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w500, color: secondaryColor),
      bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor, height: 1.6),
      bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, color: primaryColor, height: 1.5),
      bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400, color: secondaryColor, height: 1.4),
      labelLarge: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: 0.2),
      labelMedium: TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w600, color: secondaryColor, letterSpacing: 0.3),
      labelSmall: TextStyle(fontFamily: 'Outfit', fontSize: 11, fontWeight: FontWeight.w500, color: secondaryColor, letterSpacing: 0.4),
    );
  }

  // ── Curated Sanctuary Gradients (Aman Resorts, Alo Yoga) ────────────────────
  static LinearGradient get forestHeroGradient => const LinearGradient(
        colors: [Color(0xFF1B2A24), Color(0xFF243830), Color(0xFF385E4D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get emeraldGlowGradient => const LinearGradient(
        colors: [Color(0xFF5A8A70), Color(0xFF385E4D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get meditationLavenderGradient => const LinearGradient(
        colors: [Color(0xFF5D7A8C), Color(0xFF425A69)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get breathingSkyGradient => const LinearGradient(
        colors: [Color(0xFF6CA0A6), Color(0xFF4A7A80)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get goldAccentGradient => const LinearGradient(
        colors: [Color(0xFFD4AF37), Color(0xFFC5A059)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

