// ==================== lib/features/home/home_screen.dart ====================
import 'package:flutter/material.dart';
import '../../data/pediatric_kb.dart';
import '../../data/pregnancy_kb.dart';
import '../diagnosis/diagnosis_screen.dart';
import '../history/history_screen.dart';
import '../about/about_screen.dart';
import '../tips/tips_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _HeaderCard(),
          const SizedBox(height: 16),
          _MenuCard(
            icon: Icons.child_care,
            title: 'Diagnosis Penyakit Anak',
            subtitle: 'Metode Forward Chaining (38 gejala, 9 penyakit)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiagnosisFormScreen(domain: pediatricDomain),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.pregnant_woman,
            title: 'Diagnosis Penyakit pada Kehamilan',
            subtitle: 'Forward Chaining (60 gejala, 12 penyakit)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiagnosisFormScreen(domain: pregnancyDomain),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.history,
            title: 'Riwayat',
            subtitle: 'Lihat hasil diagnosis sebelumnya',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            subtitle: 'Metode dan sumber pengetahuan',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.tips_and_updates,
            title: 'Tips Kesehatan',
            subtitle: 'Kumpulan tips singkat & edukatif',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TipsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFDBEAFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_hospital, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat datang!', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                const Text('Jawab pertanyaan gejala untuk mendapatkan dugaan awal. Hasil bukan pengganti dokter.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}