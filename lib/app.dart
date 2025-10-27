// ============================ lib/app.dart ============================
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/theme_controller.dart';
// Remove this unused import
// import 'features/home/home_screen.dart';
import 'features/getstarted/get_started_screen.dart';

class PediatricPregnancyExpertApp extends StatefulWidget {
  const PediatricPregnancyExpertApp({super.key});

  @override
  State<PediatricPregnancyExpertApp> createState() => _PediatricPregnancyExpertAppState();
}

class _PediatricPregnancyExpertAppState extends State<PediatricPregnancyExpertApp> {
  final ThemeController _theme = ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _theme,
      builder: (context, _) {
        return MaterialApp(
          title: 'Sistem Pakar Medis (Anak & Kehamilan)',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: _theme.mode,
          home: const GetStartedScreen(), // Starts with GetStartedScreen
        );
      },
    );
  }
}