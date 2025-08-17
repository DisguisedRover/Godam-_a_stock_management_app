// import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color primaryRetroModern = Color(0xFF00796B);
//   static const Color accentRetroModern = Color(0xFFFFC107);
//   static const Color lightScaffoldBackground = Color(0xFFF0F4F8);
//   static const Color darkScaffoldBackground = Color(0xFF263238);
//   static const Color lightCardBackground = Colors.white;
//   static const Color darkCardBackground = Color(0xFF37474F);
//   static const Color lightInputFill = Color(0xFFF8F9FA);
//   static const Color darkInputFill = Color(0xFF455A64);
//   static const Color lightTextColor = Color(0xFF455A64);
//   static const Color darkTextColor = Color(0xFFECEFF1);

//   static ThemeData get lightTheme {
//     return ThemeData(
//       primarySwatch: _createMaterialColor(primaryRetroModern),
//       visualDensity: VisualDensity.adaptivePlatformDensity,
//       scaffoldBackgroundColor: lightScaffoldBackground,
//       appBarTheme: AppBarTheme(
//         backgroundColor: primaryRetroModern,
//         foregroundColor: Colors.white,
//         elevation: 5,
//         titleTextStyle: _textTheme.headlineMedium?.copyWith(
//           color: Colors.white,
//         ),
//       ),
//       textTheme: _textTheme,
//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.grey, width: 1.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: primaryRetroModern, width: 2.0),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.redAccent),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
//         ),
//         filled: true,
//         fillColor: lightInputFill,
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 16.0,
//           horizontal: 16.0,
//         ),
//         hintStyle: TextStyle(color: Colors.grey[600]),
//         labelStyle: TextStyle(color: primaryRetroModern),
//         errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12.0),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 50),
//           padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           backgroundColor: primaryRetroModern,
//           foregroundColor: Colors.white,
//           textStyle: const TextStyle(
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//           ),
//           elevation: 5,
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: primaryRetroModern,
//           textStyle: const TextStyle(fontSize: 16.0),
//         ),
//       ),
//       cardTheme: CardThemeData(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         margin: const EdgeInsets.all(10.0),
//         color: lightCardBackground,
//       ),
//       scrollbarTheme: ScrollbarThemeData(
//         thumbVisibility: WidgetStateProperty.all(false),
//         trackVisibility: WidgetStateProperty.all(false),
//         thumbColor: WidgetStateProperty.all(Colors.transparent),
//         trackColor: WidgetStateProperty.all(Colors.transparent),
//         thickness: WidgetStateProperty.all(0.0),
//         crossAxisMargin: 0.0,
//         mainAxisMargin: 0.0,
//       ),
//       colorScheme: ColorScheme.fromSwatch(
//         primarySwatch: _createMaterialColor(primaryRetroModern),
//         accentColor: accentRetroModern,
//         brightness: Brightness.light,
//       ).copyWith(secondary: accentRetroModern),
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primarySwatch: _createMaterialColor(primaryRetroModern),
//       visualDensity: VisualDensity.adaptivePlatformDensity,
//       scaffoldBackgroundColor: darkScaffoldBackground,
//       appBarTheme: AppBarTheme(
//         backgroundColor: darkCardBackground,
//         foregroundColor: Colors.white,
//         elevation: 5,
//         titleTextStyle: _darkTextTheme.headlineMedium?.copyWith(
//           color: Colors.white,
//         ),
//       ),
//       textTheme: _darkTextTheme,
//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide.none,
//         ),
//         filled: true,
//         fillColor: darkInputFill,
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 16.0,
//           horizontal: 16.0,
//         ),
//         hintStyle: TextStyle(color: Colors.grey[400]),
//         labelStyle: TextStyle(color: Colors.grey[200]),
//         errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12.0),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 50),
//           padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           backgroundColor: primaryRetroModern,
//           foregroundColor: Colors.white,
//           textStyle: const TextStyle(
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//           ),
//           elevation: 5,
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: accentRetroModern,
//           textStyle: const TextStyle(fontSize: 16.0),
//         ),
//       ),
//       cardTheme: CardThemeData(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         margin: const EdgeInsets.all(10.0),
//         color: darkCardBackground,
//       ),
//       scrollbarTheme: ScrollbarThemeData(
//         thumbVisibility: WidgetStateProperty.all(false),
//         trackVisibility: WidgetStateProperty.all(false),
//         thumbColor: WidgetStateProperty.all(Colors.transparent),
//         trackColor: WidgetStateProperty.all(Colors.transparent),
//         thickness: WidgetStateProperty.all(0.0),
//         crossAxisMargin: 0.0,
//         mainAxisMargin: 0.0,
//       ),
//       colorScheme: ColorScheme.fromSwatch(
//         primarySwatch: _createMaterialColor(primaryRetroModern),
//         accentColor: accentRetroModern,
//         brightness: Brightness.dark,
//       ).copyWith(secondary: accentRetroModern),
//     );
//   }

//   static MaterialColor _createMaterialColor(Color color) {
//     List strengths = <double>[.05];
//     Map<int, Color> swatch = {};
//     final int r = color.red, g = color.green, b = color.blue;

//     for (int i = 1; i < 10; i++) {
//       strengths.add(0.1 * i);
//     }
//     for (var strength in strengths) {
//       final double ds = 0.5 - strength;
//       swatch[(strength * 1000).round()] = Color.fromRGBO(
//         r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//         g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//         b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//         1,
//       );
//     }
//     return MaterialColor(color.value, swatch);
//   }

//   static const TextTheme _textTheme = TextTheme(
//     headlineLarge: TextStyle(
//       fontSize: 32.0,
//       fontWeight: FontWeight.bold,
//       color: lightTextColor, // Use new text color
//     ),
//     headlineMedium: TextStyle(
//       fontSize: 24.0,
//       fontWeight: FontWeight.bold,
//       color: lightTextColor, // Use new text color
//     ),
//     bodyLarge: TextStyle(
//       fontSize: 16.0,
//       color: lightTextColor,
//     ), // Use new text color
//     bodyMedium: TextStyle(
//       fontSize: 14.0,
//       color: lightTextColor,
//     ), // Use new text color
//     labelLarge: TextStyle(
//       fontSize: 16.0,
//       fontWeight: FontWeight.w600,
//       color: Colors.white, // Still white for buttons
//     ),
//     titleMedium: TextStyle(
//       // Added this for consistency with card titles
//       fontSize: 18.0,
//       fontWeight: FontWeight.bold,
//       color: lightTextColor,
//     ),
//     bodySmall: TextStyle(
//       // Added this for consistency with chip text
//       fontSize: 12.0,
//       color: lightTextColor,
//     ),
//   );

//   static const TextTheme _darkTextTheme = TextTheme(
//     headlineLarge: TextStyle(
//       fontSize: 32.0,
//       fontWeight: FontWeight.bold,
//       color: darkTextColor, // Use new dark text color
//     ),
//     headlineMedium: TextStyle(
//       fontSize: 24.0,
//       fontWeight: FontWeight.bold,
//       color: darkTextColor, // Use new dark text color
//     ),
//     bodyLarge: TextStyle(
//       fontSize: 16.0,
//       color: darkTextColor,
//     ), // Use new dark text color
//     bodyMedium: TextStyle(
//       fontSize: 14.0,
//       color: darkTextColor,
//     ), // Use new dark text color
//     labelLarge: TextStyle(
//       fontSize: 16.0,
//       fontWeight: FontWeight.w600,
//       color: Colors.white, // Still white for buttons
//     ),
//     titleMedium: TextStyle(
//       // Added this for consistency with card titles
//       fontSize: 18.0,
//       fontWeight: FontWeight.bold,
//       color: darkTextColor,
//     ),
//     bodySmall: TextStyle(
//       // Added this for consistency with chip text
//       fontSize: 12.0,
//       color: darkTextColor,
//     ),
//   );
// }

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRetroModern = Color(0xFF00796B); // Deep Teal
  static const Color accentRetroModern = Color(0xFFFFC107); // Amber

  static const Color lightScaffoldBackground = Color(0xFFEFEFEF);
  static const Color lightCardBackground = Colors.white;
  static const Color lightInputFill = Color(0xFFF8F9FA);
  static const Color lightTextColor = Color(0xFF333333);
  static const Color lightBorderColor = Color(0xFFCCCCCC);

  static const Color darkScaffoldBackground = Color(0xFF212121);
  static const Color darkCardBackground = Color(0xFF2D2D2D);
  static const Color darkInputFill = Color(0xFF3A3A3A);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(primaryRetroModern),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: lightScaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryRetroModern,
        foregroundColor: Colors.white,
        elevation: 5,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: _textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: lightBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: lightBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryRetroModern, width: 2.0),
        ),
        filled: true,
        fillColor: lightInputFill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        hintStyle: TextStyle(color: Colors.grey[600]),
        labelStyle: const TextStyle(color: lightTextColor),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: primaryRetroModern,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          elevation: 5,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRetroModern,
          textStyle: const TextStyle(fontSize: 16.0),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        margin: EdgeInsets.all(10.0),
        color: lightCardBackground,
      ),
      dividerColor: lightBorderColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: _createMaterialColor(primaryRetroModern),
        accentColor: accentRetroModern,
        brightness: Brightness.light,
      ).copyWith(secondary: accentRetroModern),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(primaryRetroModern),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: darkScaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCardBackground,
        foregroundColor: Colors.white,
        elevation: 5,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: _darkTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF616161)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF616161)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: accentRetroModern, width: 2.0),
        ),
        filled: true,
        fillColor: darkInputFill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
        labelStyle: const TextStyle(color: darkTextColor),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: primaryRetroModern,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          elevation: 5,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentRetroModern,
          textStyle: const TextStyle(fontSize: 16.0),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        margin: EdgeInsets.all(10.0),
        color: darkCardBackground,
      ),
      dividerColor: const Color(0xFF616161),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: _createMaterialColor(primaryRetroModern),
        accentColor: accentRetroModern,
        brightness: Brightness.dark,
      ).copyWith(secondary: accentRetroModern),
    );
  }

  static MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static const TextTheme _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: lightTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: lightTextColor,
    ),
    bodyLarge: TextStyle(fontSize: 16.0, color: lightTextColor),
    bodyMedium: TextStyle(fontSize: 14.0, color: lightTextColor),
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: lightTextColor,
    ),
    bodySmall: TextStyle(fontSize: 12.0, color: lightTextColor),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: darkTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: darkTextColor,
    ),
    bodyLarge: TextStyle(fontSize: 16.0, color: darkTextColor),
    bodyMedium: TextStyle(fontSize: 14.0, color: darkTextColor),
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: darkTextColor,
    ),
    bodySmall: TextStyle(fontSize: 12.0, color: darkTextColor),
  );
}
