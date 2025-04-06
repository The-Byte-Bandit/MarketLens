import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/news_provider.dart';
import './providers/theme_provider.dart';
import './views/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider()..loadSavedArticles(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'MarketLens',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0A192F),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0A192F),
        secondary: Color(0xFF64FFDA),
        surface: Color(0xFF172A45),
      ),
      scaffoldBackgroundColor: const Color(0xFF0A192F),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0A192F),
        titleTextStyle: GoogleFonts.audiowide(
          // Only the app bar title uses Audiowide
          color: const Color(0xFF64FFDA),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF64FFDA)),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF172A45),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0A192F),
        selectedItemColor: Color(0xFF64FFDA),
        unselectedItemColor: Color(0xFF8892B0),
      ),
      textTheme: const TextTheme(
        // All other text uses default font
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        labelLarge: TextStyle(color: Color(0xFF64FFDA)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF172A45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Color(0xFF8892B0)),
        prefixIconColor: const Color(0xFF64FFDA),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        secondary: Color(0xFF0A192F),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: GoogleFonts.audiowide(
          // Only the app bar title uses Audiowide
          color: const Color(0xFF0A192F),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0A192F)),
      ),
      textTheme: const TextTheme(
        // All other text uses default font
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        titleMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        labelLarge: TextStyle(color: Color(0xFF0A192F)),
      ),
      // Add other light theme properties as needed
    );
  }
}
