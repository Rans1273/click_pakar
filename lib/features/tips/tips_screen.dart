// ======================= lib/features/tips/tips_screen.dart =======================
import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Minum air putih 8 gelas/hari—lebih saat demam/diare.',
      'Cuci tangan 20 detik sebelum menyentuh bayi/ibu hamil.',
      'Kenali tanda bahaya: kejang, perdarahan, sesak berat, penurunan kesadaran.',
      'Pada kehamilan: ukur tekanan darah rutin dan batasi garam jika dianjurkan.',
      'Demam pada anak: kompres hangat, pakaian tipis, pantau suhu tiap 4 jam.',
      'Batuk pilek: tidur berkepala agak tinggi, humidifier jika tersedia.',
      'Makanan aman: hindari daging setengah matang pada ibu hamil (toksoplasma).',
      'Jadwalkan imunisasi & kontrol ANC tepat waktu.',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tips Kesehatan')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => Card(
          child: ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(tips[i])),
        ),
      ),
    );
  }
}