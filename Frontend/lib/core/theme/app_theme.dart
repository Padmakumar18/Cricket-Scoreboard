import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color secondaryColor = Color(0xFF0D47A1);
  static const Color accentColor = Color(0xFF4FC3F7);
  static const Color backgroundColor = Color(0xFF0A1929);
  static const Color surfaceColor = Color(0xFF1E293B);
  static const Color cardColor = Color(0xFF334155);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}

class AppConstants {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static const EdgeInsets mobilePadding = EdgeInsets.all(16);
  static const EdgeInsets tabletPadding = EdgeInsets.all(24);
  static const EdgeInsets desktopPadding = EdgeInsets.all(32);

  static const double mobileButtonHeight = 48;
  static const double tabletButtonHeight = 56;
  static const double desktopButtonHeight = 64;

  static EdgeInsets getResponsivePadding(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return mobilePadding;
    } else if (screenWidth < tabletBreakpoint) {
      return tabletPadding;
    } else {
      return desktopPadding;
    }
  }

  static double getResponsiveButtonHeight(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return mobileButtonHeight;
    } else if (screenWidth < tabletBreakpoint) {
      return tabletButtonHeight;
    } else {
      return desktopButtonHeight;
    }
  }

  static int getResponsiveColumns(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return 2;
    } else if (screenWidth < tabletBreakpoint) {
      return 3;
    } else {
      return 4;
    }
  }
}
