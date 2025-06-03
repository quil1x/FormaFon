// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './providers/configurator_provider.dart';
import './screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFFF5F7FA),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF26A69A);
    const lightGreenAccent = Color(0xFF69F0AE);
    const backgroundColor = Color(0xFFF5F7FA);
    const surfaceColor = Colors.white;
    const onPrimaryColor = Colors.white;
    const onSecondaryColorForScheme = Colors.black; // For text on secondaryColor elements
    const onSurfaceColor = Color(0xFF263238);
    const onBackgroundColorForScheme = Color(0xFF37474F);

    final ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light( // Made const
        primary: primaryGreen,
        secondary: lightGreenAccent,
        surface: surfaceColor, // Use this for scaffold's background
        error: Colors.redAccent,
        onPrimary: onPrimaryColor,
        onSecondary: onSecondaryColorForScheme,
        onSurface: onSurfaceColor, // Use this for text on cards, surfaces
        // onBackground: onBackgroundColorForScheme, // Видалено, оскільки застаріле
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme( // Додано const
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle( // Added const
          color: primaryGreen,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Nunito',
        ),
        iconTheme: IconThemeData(color: primaryGreen, size: 26), // Added const
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: onPrimaryColor,
          shape: RoundedRectangleBorder( // Can be const if radius is const
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28), // Added const
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Nunito', letterSpacing: 0.5), // Added const
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: BorderSide(color: primaryGreen.withAlpha((0.7 * 255).round()), width: 1.5), // Corrected
          shape: RoundedRectangleBorder( // Can be const
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Added const
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Nunito') // Added const
        )
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
           textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Nunito') // Added const
        )
      ),
      inputDecorationTheme: const InputDecorationTheme( // Made const
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400), // Fixed: Colors.grey is already const
        labelStyle: TextStyle(color: primaryGreen, fontWeight: FontWeight.w500, fontSize: 16), // Added const
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Added const
        border: OutlineInputBorder( // Made const
          borderRadius: BorderRadius.all(Radius.circular(12.0)), // Corrected const for BorderRadius
          borderSide: BorderSide(color: Colors.grey, width: 1.0), // Fixed: Colors.grey is already const
        ),
        enabledBorder: OutlineInputBorder( // Made const
          borderRadius: BorderRadius.all(Radius.circular(12.0)), // Corrected const for BorderRadius
          borderSide: BorderSide(color: Colors.grey, width: 1.0), // Matched border
        ),
        focusedBorder: OutlineInputBorder( // Made const
          borderRadius: BorderRadius.all(Radius.circular(12.0)), // Corrected const for BorderRadius
          borderSide: BorderSide(color: primaryGreen, width: 2.0), // Corrected
        ),
        errorBorder: OutlineInputBorder( // Made const
          borderRadius: BorderRadius.all(Radius.circular(12.0)), // Corrected const for BorderRadius
          borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder( // Made const
          borderRadius: BorderRadius.all(Radius.circular(12.0)), // Corrected const for BorderRadius
          borderSide: BorderSide(color: Colors.redAccent, width: 1.8),
        ),
      ),
      iconTheme: const IconThemeData( // Added const
        color: onSurfaceColor, // Use onSurfaceColor for general icons on light backgrounds
        size: 22,
      ),
      chipTheme: ChipThemeData( // Can be const
        backgroundColor: primaryGreen.withAlpha((0.1 * 255).round()), // Corrected
        labelStyle: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w600, fontSize: 13), // Added const
        secondaryLabelStyle: TextStyle(color: Colors.grey[700]),
        selectedColor: primaryGreen,
        checkmarkColor: onPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Added const
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))), // Corrected const for RoundedRectangleBorder
        side: BorderSide.none,
      ),
      dividerTheme: const DividerThemeData( // Made const
        color: Colors.grey, // Fixed: Colors.grey is already const
        thickness: 0.8,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData( // Змінено на non-const, оскільки modalBackgroundColor динамічна
        backgroundColor: surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        elevation: 5,
        modalBackgroundColor: Colors.black.withAlpha((0.26 * 255).round()), // Замінено const на Colors.black.withAlpha
      ),
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Nunito',
            bodyColor: onBackgroundColorForScheme, // Use onBackgroundColorForScheme
            displayColor: primaryGreen,
          ).copyWith(
            headlineMedium: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w700, letterSpacing: 0.3, fontFamily: 'Nunito'), // Added const
            headlineSmall: const TextStyle(color: onBackgroundColorForScheme, fontWeight: FontWeight.w600, fontFamily: 'Nunito'), // Changed color
            titleLarge: const TextStyle(color: onBackgroundColorForScheme, fontWeight: FontWeight.bold, fontFamily: 'Nunito'), // Changed color
            titleMedium: TextStyle(color: onBackgroundColorForScheme.withAlpha((0.9 * 255).round()), fontWeight: FontWeight.w600, fontFamily: 'Nunito'), // Corrected
            bodyLarge: TextStyle(color: onBackgroundColorForScheme.withAlpha((0.85 * 255).round()), fontSize: 16, height: 1.45, fontFamily: 'Nunito'), // Corrected
            bodyMedium: TextStyle(color: onBackgroundColorForScheme.withAlpha((0.8 * 255).round()), fontSize: 15, height: 1.4, fontFamily: 'Nunito'), // Corrected
            bodySmall: TextStyle(color: onBackgroundColorForScheme.withAlpha((0.7 * 255).round()), fontSize: 13, fontFamily: 'Nunito'), // Corrected
            labelLarge: const TextStyle(color: onPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Nunito', letterSpacing: 0.5) // Added const
          ),
    );

    return ChangeNotifierProvider(
      create: (ctx) => ConfiguratorProvider(),
      child: MaterialApp(
        title: 'FormaFon Lviv',
        theme: lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}