// ======================= lib/features/tips/tips_screen.dart =======================
import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Pantau tekanan darah & kadar gula pada kehamilan berisiko.',
      'Cukupkan cairan saat demam/diare, gunakan termometer digital.',
      'Kenali tanda bahaya: kejang, perdarahan, nyeri kepala berat, gangguan visus.',
      'Kontrol ANC teratur dan lengkapi imunisasi anak.',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tips Kesehatan')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => const Card(
          child: ListTile(leading: Icon(Icons.check_circle_outline), title: Text('')), // placeholder, diisi di bawah
        ),
      ),
    );
  }
}
