import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.background,
      ),
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.poppins(
            fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black),
        headlineMedium: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        headlineLarge: GoogleFonts.poppins(
            fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
        titleSmall: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        titleLarge: GoogleFonts.poppins(
            fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
        bodySmall: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
            color: Colors.black),
        bodyMedium: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),

      // Button Theme (Deprecated but still useful for older widgets)
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textTheme: ButtonTextTheme.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.orange,
          side: const BorderSide(color: Colors.orange),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.black,

      // Text Theme
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        headlineMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        headlineLarge: TextStyle(
            fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
        titleSmall: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        titleLarge: TextStyle(
            fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
        bodySmall: TextStyle(
            fontSize: 12.sp, fontWeight: FontWeight.normal, color: Colors.grey),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),

      // Button Theme
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textTheme: ButtonTextTheme.primary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.orange,
          side: const BorderSide(color: Colors.orange),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AppColors {
  static const Color primary = Color(0xffFFB600);
  static const Color secondary = Color(0xFF9BC53D);
  static const Color background = Color(0xFF0E696C);
  static const Color text = Colors.black87;
  static const Color error = Colors.redAccent;
  static const Color authHeading = Color(0xFFEB6E0F);
  static const Color ScreenColor = Color(0xFFF5F5F5);
}
