// ====================== lib/features/about/about_screen.dart ======================
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Metode', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('Aplikasi menggunakan pendekatan Sistem Pakar. Pengguna memasukkan fakta (gejala), mesin mencocokkan aturan, lalu menyajikan dugaan penyakit secara berperingkat.'),
          SizedBox(height: 16),
          Text('Disclaimer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('Hasil bukan diagnosis medis final dan tidak menggantikan konsultasi dokter. Jika ada tanda bahaya (perdarahan, kejang, sesak berat, penurunan kesadaran), segera ke IGD.'),
        ]),
      ),
    );
  }
}