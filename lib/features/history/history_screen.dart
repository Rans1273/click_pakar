// ==================== lib/features/history/history_screen.dart ====================
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: const Center(
        child: Text('Belum ada riwayat tersimpan. (Integrasikan SharedPreferences/SQLite)'),
      ),
    );
  }
}