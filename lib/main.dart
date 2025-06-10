// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/configurator_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // === КОЛЬОРИ ЗАЛИШАЮТЬСЯ ТИМИ Ж САМИМИ ===
    const primaryRedLight = Color(0xFFE54B4B);
    const backgroundBeigeLight = Color(0xFFE6DED0);
    const surfaceBeigeLight = Color(0xFFF0E7D6);
    const shadowLight = Color(0xFFAFA597);
    const highlightLight = Color(0xFFFFFFFF);
    const onSurfaceLight = Color(0xFF3D352E);

    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryRedLight,
      scaffoldBackgroundColor: backgroundBeigeLight,
      // FIX: Застосовуємо шрифт Unbounded
      fontFamily: 'Unbounded',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRedLight,
        brightness: Brightness.light,
        surface: surfaceBeigeLight,
        onSurface: onSurfaceLight,
      ).copyWith(
        shadow: shadowLight,
        surfaceTint: highlightLight,
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Unbounded'),
    );

    // === ТЕМНА ТЕМА ===
    const primaryRedDark = Color(0xFFF28B82);
    const backgroundDark = Color(0xFF212121);
    const surfaceDark = Color(0xFF2A2A2A);
    const shadowDark = Color(0xFF121212);
    const highlightDark = Color(0xFF353535);
    const onSurfaceDark = Color(0xFFE0E0E0);

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryRedDark,
      scaffoldBackgroundColor: backgroundDark,
      // FIX: Застосовуємо шрифт Unbounded
      fontFamily: 'Unbounded',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRedDark,
        brightness: Brightness.dark,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
      ).copyWith(
        shadow: shadowDark,
        surfaceTint: highlightDark,
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Unbounded'),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ConfiguratorProvider()),
        ChangeNotifierProvider(create: (ctx) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          final systemUiOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: settings.isDarkMode ? Brightness.light : Brightness.dark,
          );
          SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

          return MaterialApp(
            title: 'FormaFon',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: const [Locale('uk', ''), Locale('en', '')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}