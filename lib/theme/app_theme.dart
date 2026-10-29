import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // ARTBRIDGE BRAND COLORS
  // ============================================================

  static const Color warmCream = Color(0xFFF7F5EF);
  static const Color oliveGreen = Color(0xFF65705B);
  static const Color darkOlive = Color(0xFF4D5845);
  static const Color charcoal = Color(0xFF182019);
  static const Color softGray = Color(0xFF697067);
  static const Color white = Color(0xFFFFFFFF);

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // ==========================================================
    // COLOR SCHEME
    // ==========================================================

    colorScheme: const ColorScheme.light(
      primary: oliveGreen,
      onPrimary: white,

      secondary: darkOlive,
      onSecondary: white,

      surface: white,
      onSurface: charcoal,

      error: Color(0xFFB3261E),
      onError: white,
    ),

    // ==========================================================
    // GENERAL
    // ==========================================================

    scaffoldBackgroundColor: warmCream,

    // ==========================================================
    // APP BAR
    // ==========================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: warmCream,
      foregroundColor: charcoal,
      elevation: 0,
      centerTitle: false,

      titleTextStyle: TextStyle(
        color: charcoal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
    ),

    // ==========================================================
    // TEXT THEME
    // ==========================================================

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      headlineSmall: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        color: softGray,
        decoration: TextDecoration.none,
      ),

      bodySmall: TextStyle(
        fontSize: 12,
        color: softGray,
        decoration: TextDecoration.none,
      ),

      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: charcoal,
        decoration: TextDecoration.none,
      ),

      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: softGray,
        decoration: TextDecoration.none,
      ),

      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: softGray,
        decoration: TextDecoration.none,
      ),
    ),

    // ==========================================================
    // CARD
    // ==========================================================

    cardTheme: CardThemeData(
      elevation: 0,
      color: white,
      surfaceTintColor: Colors.transparent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    // ==========================================================
    // ELEVATED BUTTON
    // ==========================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: oliveGreen,
        foregroundColor: white,

        minimumSize: const Size(double.infinity, 52),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    ),

    // ==========================================================
    // OUTLINED BUTTON
    // ==========================================================

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkOlive,

        side: const BorderSide(
          color: oliveGreen,
          width: 1.5,
        ),

        minimumSize: const Size(double.infinity, 52),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    ),

    // ==========================================================
    // TEXT BUTTON
    // ==========================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: oliveGreen,

        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    ),

    // ==========================================================
    // INPUT FIELDS
    // ==========================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: oliveGreen,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFB3261E),
          width: 1.5,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFB3261E),
          width: 2,
        ),
      ),

      hintStyle: const TextStyle(
        color: softGray,
        fontSize: 14,
        decoration: TextDecoration.none,
      ),

      labelStyle: const TextStyle(
        color: softGray,
        fontSize: 14,
        decoration: TextDecoration.none,
      ),

      prefixIconColor: oliveGreen,
      suffixIconColor: softGray,
    ),

    // ==========================================================
    // NAVIGATION BAR
    // ==========================================================

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: white,

      indicatorColor: const Color(0xFFE1E5DC),

      elevation: 0,

      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: charcoal,
          decoration: TextDecoration.none,
        ),
      ),

      iconTheme: WidgetStateProperty.all(
        const IconThemeData(
          color: oliveGreen,
          size: 24,
        ),
      ),
    ),

    // ==========================================================
    // ICONS
    // ==========================================================

    iconTheme: const IconThemeData(
      color: oliveGreen,
    ),

    // ==========================================================
    // DIVIDERS
    // ==========================================================

    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E3DC),
      thickness: 1,
      space: 1,
    ),

    // ==========================================================
    // CHECKBOX
    // ==========================================================

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return oliveGreen;
          }

          return white;
        },
      ),
      checkColor: WidgetStateProperty.all(white),
    ),

    // ==========================================================
    // SWITCH
    // ==========================================================

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return oliveGreen;
          }

          return softGray;
        },
      ),
    ),

    // ==========================================================
    // TEXT SELECTION
    // ==========================================================

    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color(0x3365705B),
      cursorColor: oliveGreen,
      selectionHandleColor: oliveGreen,
    ),
  );
}