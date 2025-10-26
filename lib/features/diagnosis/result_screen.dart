// ============== lib/features/diagnosis/result_screen.dart ==============
import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/engine.dart';

class ResultScreen extends StatelessWidget {
  final DomainConfig domain;
  final Set<String> facts;
  final List<dynamic> answers; // _AnswerLog from diagnosis_screen.dart
  final List<MapEntry<String, DiseaseMatch>> ranked;
  const ResultScreen({super.key, required this.domain, required this.facts, required this.answers, required this.ranked});

  @override
  Widget build(BuildContext context) {
    final best = ranked.isNotEmpty ? ranked.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Diagnosis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (best != null) _BestDiagnosisCard(domain: domain, entry: best),
          const SizedBox(height: 16),
          Text('Peringkat Diagnosa', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...ranked.map((e) => _RankTile(domain: domain, entry: e)),
          const SizedBox(height: 16),
          Text('Jawaban Anda', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...answers.map((a) => ListTile(
                dense: true,
                leading: Icon(a.yes ? Icons.check_circle : Icons.cancel),
                title: Text(a.text),
                trailing: Text(a.yes ? 'Ya' : 'Tidak'),
              )),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.home),
            label: const Text('Kembali ke Beranda'),
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
          ),
        ],
      ),
    );
  }
}

class _BestDiagnosisCard extends StatelessWidget {
  final DomainConfig domain;
  final MapEntry<String, DiseaseMatch> entry;
  const _BestDiagnosisCard({required this.domain, required this.entry});

  @override
  Widget build(BuildContext context) {
    final dz = domain.diseases.firstWhere((d) => d.code == entry.key);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F9FF), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Dugaan Utama – ${domain.code}', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.local_hospital, size: 36),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(dz.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text('${(entry.value.finalScore * 100).toStringAsFixed(1)}% kecocokan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
          ])),
          TextButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => _DiseaseDetailSheet(domain: domain, disease: dz, match: entry.value),
            ),
            child: const Text('Detail'),
          ),
        ]),
      ]),
    );
  }
}

class _RankTile extends StatelessWidget {
  final DomainConfig domain;
  final MapEntry<String, DiseaseMatch> entry;
  const _RankTile({required this.domain, required this.entry});

  @override
  Widget build(BuildContext context) {
    final dz = domain.diseases.firstWhere((d) => d.code == entry.key);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.assignment),
        title: Text(dz.name),
        subtitle: Text('Skor: ${(entry.value.finalScore * 100).toStringAsFixed(1)}%  ·  Aturan: ${entry.value.satisfiedRules}/${entry.value.totalRules}'),
        trailing: TextButton(
          child: const Text('Info'),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => _DiseaseDetailSheet(domain: domain, disease: dz, match: entry.value),
          ),
        ),
      ),
    );
  }
}

class _DiseaseDetailSheet extends StatelessWidget {
  final DomainConfig domain;
  final Disease disease;
  final DiseaseMatch match;
  const _DiseaseDetailSheet({required this.domain, required this.disease, required this.match});

  @override
  Widget build(BuildContext context) {
    final matched = match.matchedSymptoms.toList()..sort();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: ListView(controller: controller, children: [
          Center(child: Container(height: 4, width: 48, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)))),
          Text(disease.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(disease.description),
          const SizedBox(height: 12),
          Text('Pertolongan Pertama', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(disease.firstAid),
          const SizedBox(height: 12),
          Text('Gejala Terpenuhi', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          if (matched.isEmpty) const Text('Belum ada gejala yang cocok.'),
          if (matched.isNotEmpty)
            Wrap(spacing: 8, runSpacing: 8, children: matched.map((code) {
              final label = domain.symptoms.firstWhere((s) => s.code == code).question
                  .replaceFirst('Apakah ', '').replaceAll('?', '');
              return Chip(label: Text('$code – $label'));
            }).toList()),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ]),
      ),
    );
  }
}