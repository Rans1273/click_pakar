// lib/main.dart
// Flutter app: Expert System (Forward Chaining) to diagnose 9 pediatric diseases from 38 symptoms.
// NOTE: The rule base below is adapted from the PDF's disease & symptom set.
// You can fine-tune the mapping in `_knowledgeBase` to exactly match your expert's rules.
// This single-file demo keeps dependencies minimal (only Flutter SDK).

import 'package:flutter/material.dart';

void main() => runApp(const PediatricExpertApp());

class PediatricExpertApp extends StatelessWidget {
  const PediatricExpertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pakar Anak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const GetStartedScreen(),
    );
  }
}

// ------------------------------- MODELS -------------------------------
class Symptom {
  final String code;
  final String question; // phrased as question for UI
  const Symptom(this.code, this.question);
}

class Disease {
  final String code;
  final String name;
  final String description;
  final String firstAid;
  const Disease({
    required this.code,
    required this.name,
    required this.description,
    required this.firstAid,
  });
}

class Rule { // IF all symptoms THEN disease
  final String diseaseCode;
  final Set<String> requiredSymptoms; // codes required (AND)
  const Rule({required this.diseaseCode, required this.requiredSymptoms});
}

// ------------------------ KNOWLEDGE BASE (DATA) ------------------------
// 9 Diseases (P01..P09) & 38 Symptoms (G01..G38). Questions are simplified Bahasa.
// Source list per PDF: Asma, Bronchopneumonia, Tifoid, DBD, TBC, Tonsilitis, Leukemia, Malaria, Meningitis.
// (See README/skripsi PDF for the canonical list.)

const diseases = <Disease>[
  Disease(
    code: 'P01',
    name: 'Asma',
    description:
        'Penyakit dengan penyempitan saluran napas yang menimbulkan sesak dan wheezing.',
    firstAid:
        'Jauhkan dari pemicu, posisikan duduk tegak, bantu gunakan inhaler jika tersedia, pantau napas.'
  ),
  Disease(
    code: 'P02',
    name: 'Bronkopneumonia',
    description:
        'Infeksi paru yang menyebabkan batuk produktif, demam, dan napas berbunyi.',
    firstAid:
        'Istirahat, cukup cairan, kompres hangat, rujuk ke fasilitas kesehatan bila sesak memburuk.'
  ),
  Disease(
    code: 'P03',
    name: 'Tifoid',
    description:
        'Infeksi saluran cerna (demam tifoid) dengan demam lama, gangguan pencernaan, perubahan pada lidah.',
    firstAid:
        'Cairan oral, makanan lunak sedikit tapi sering, segera periksa bila demam tinggi berkepanjangan.'
  ),
  Disease(
    code: 'P04',
    name: 'DBD (Dengue)',
    description:
        'Infeksi virus dengue dengan demam fase kritis, nyeri otot, perdarahan ringan, ruam.',
    firstAid:
        'Cairan yang cukup, pantau tanda bahaya (perdarahan, muntah terus), segera ke IGD bila memburuk.'
  ),
  Disease(
    code: 'P05',
    name: 'TBC',
    description:
        'Tuberkulosis: batuk lama, keringat malam, berat badan turun.',
    firstAid:
        'Gunakan masker bila batuk, periksakan ke puskesmas untuk tes dan terapi OAT.'
  ),
  Disease(
    code: 'P06',
    name: 'Tonsilitis',
    description:
        'Radang amandel: nyeri tenggorokan/menelan, mulut berbau, lidah tampak kotor/ujung kemerahan.',
    firstAid:
        'Kumur air hangat, hidrasi, obat simtomatik, evaluasi dokter bila demam tinggi/nyeri berat.'
  ),
  Disease(
    code: 'P07',
    name: 'Leukemia',
    description:
        'Keganasan darah: pucat, perdarahan gusi, memar tanpa sebab, nyeri tulang, pembesaran KGB.',
    firstAid:
        'Segera rujuk ke fasilitas kesehatan untuk evaluasi lengkap. Hindari aktivitas berat jika mudah memar.'
  ),
  Disease(
    code: 'P08',
    name: 'Malaria',
    description:
        'Infeksi parasit dengan demam periodik, menggigil, keringat banyak, pucat.',
    firstAid:
        'Kompres, cairan cukup, segera periksa untuk tes malaria bila tinggal/pergi ke daerah endemis.'
  ),
  Disease(
    code: 'P09',
    name: 'Meningitis',
    description:
        'Radang selaput otak: sakit kepala, muntah, kejang, penurunan kesadaran, tangisan merintih pada bayi.',
    firstAid:
        'Kondisi gawat darurat—segera ke IGD. Jaga jalan napas dan posisi aman saat kejang.'
  ),
];

// 38 symptoms, phrased as Y/N questions for the form. (Codes from the PDF)
const symptoms = <Symptom>[
  Symptom('G01', 'Apakah anak batuk kering?'),
  Symptom('G02', 'Apakah anak tampak gelisah/khawatir?'),
  Symptom('G03', 'Apakah anak sulit berbicara?'),
  Symptom('G04', 'Apakah tingkat kesadaran menurun? (mengantuk berat/ sulit dibangunkan)'),
  Symptom('G05', 'Apakah anak sesak napas?'),
  Symptom('G06', 'Apakah batuk produktif dan kuat?'),
  Symptom('G07', 'Apakah anak merasa dada sesak?'),
  Symptom('G08', 'Apakah napas berbunyi (wheezing)?'),
  Symptom('G09', 'Apakah demam 2–4 hari (>38°C)?'),
  Symptom('G10', 'Apakah demam 5–7 hari (>38°C)?'),
  Symptom('G11', 'Apakah anak menggigil?'),
  Symptom('G12', 'Apakah anak nyeri otot?'),
  Symptom('G13', 'Apakah ada nyeri perut bagian atas?'),
  Symptom('G14', 'Apakah berkeringat banyak?'),
  Symptom('G15', 'Apakah sakit kepala?'),
  Symptom('G16', 'Apakah muntah?'),
  Symptom('G17', 'Apakah diare?'),
  Symptom('G18', 'Apakah nafsu makan berkurang?'),
  Symptom('G19', 'Apakah berat badan turun?'),
  Symptom('G20', 'Apakah lidah tampak kotor di bagian tengah?'),
  Symptom('G21', 'Apakah ujung lidah tampak merah?'),
  Symptom('G22', 'Apakah nyeri tenggorokan?'),
  Symptom('G23', 'Apakah anak tampak lesu?'),
  Symptom('G24', 'Apakah bayi/anak menangis merintih (high-pitched cry)?'),
  Symptom('G25', 'Apakah batuk > 3 minggu dan kadang berdarah?'),
  Symptom('G26', 'Apakah gusi sering berdarah?'),
  Symptom('G27', 'Apakah terjadi kejang?'),
  Symptom('G28', 'Apakah keringat malam tanpa aktivitas?'),
  Symptom('G29', 'Apakah flu > 3 minggu?'),
  Symptom('G30', 'Apakah mudah memar tanpa sebab?'),
  Symptom('G31', 'Apakah ada pembesaran kelenjar getah bening?'),
  Symptom('G32', 'Apakah nyeri tulang?'),
  Symptom('G33', 'Apakah demam turun tiba-tiba? (fase kritis dengue)'),
  Symptom('G34', 'Apakah nyeri menelan?'),
  Symptom('G35', 'Apakah muncul kemerahan/ruam pada kulit?'),
  Symptom('G36', 'Apakah anak malas minum?'),
  Symptom('G37', 'Apakah pucat?'),
  Symptom('G38', 'Apakah mulut berbau?'),
];

// Minimal forward-chaining rules (AND). You can expand with more detailed branching.
// These are reasonable clinical-style mappings aligned to the symptom list; adjust per your expert.
const _knowledgeBase = <Rule>[
  // Asma
  Rule(diseaseCode: 'P01', requiredSymptoms: {'G05', 'G08'}), // sesak + wheeze
  Rule(diseaseCode: 'P01', requiredSymptoms: {'G05', 'G07', 'G08'}),

  // Bronkopneumonia
  Rule(diseaseCode: 'P02', requiredSymptoms: {'G06', 'G08', 'G09'}),
  Rule(diseaseCode: 'P02', requiredSymptoms: {'G06', 'G08', 'G10'}),

  // Tifoid
  Rule(diseaseCode: 'P03', requiredSymptoms: {'G10', 'G13', 'G17'}),
  Rule(diseaseCode: 'P03', requiredSymptoms: {'G10', 'G20'}),

  // DBD
  Rule(diseaseCode: 'P04', requiredSymptoms: {'G10', 'G12', 'G35'}),
  Rule(diseaseCode: 'P04', requiredSymptoms: {'G33', 'G26'}),

  // TBC
  Rule(diseaseCode: 'P05', requiredSymptoms: {'G25', 'G28', 'G19'}),

  // Tonsilitis
  Rule(diseaseCode: 'P06', requiredSymptoms: {'G22', 'G34'}),
  Rule(diseaseCode: 'P06', requiredSymptoms: {'G22', 'G38'}),
  Rule(diseaseCode: 'P06', requiredSymptoms: {'G20', 'G21'}),

  // Leukemia
  Rule(diseaseCode: 'P07', requiredSymptoms: {'G26', 'G30', 'G31'}),
  Rule(diseaseCode: 'P07', requiredSymptoms: {'G37', 'G32'}),

  // Malaria
  Rule(diseaseCode: 'P08', requiredSymptoms: {'G11', 'G14', 'G37'}),
  Rule(diseaseCode: 'P08', requiredSymptoms: {'G09', 'G11', 'G14'}),

  // Meningitis
  Rule(diseaseCode: 'P09', requiredSymptoms: {'G15', 'G16', 'G27'}),
  Rule(diseaseCode: 'P09', requiredSymptoms: {'G04', 'G27'}),
];

// ----------------------- INFERENCE ENGINE (FC) ------------------------
class ForwardChainingEngine {
  final List<Rule> rules;
  ForwardChainingEngine(this.rules);

  /// Returns a score per disease based on how many rule antecedents are satisfied.
  /// Highest score(s) are suggested diagnoses. Also returns matched symptoms per disease.
  Map<String, DiseaseMatch> infer(Set<String> facts) {
    final Map<String, DiseaseMatch> scores = {};
    for (final r in rules) {
      final matched = r.requiredSymptoms.intersection(facts).length;
      final total = r.requiredSymptoms.length;
      final ok = matched == total; // rule satisfied

      final dm = scores.putIfAbsent(r.diseaseCode, () => DiseaseMatch());
      dm.totalRules += 1;
      dm.totalAntecedents += total;
      dm.matchedAntecedents += matched;
      if (ok) dm.satisfiedRules += 1;
      dm.matchedSymptoms.addAll(r.requiredSymptoms.intersection(facts));
    }
    return scores;
  }
}

class DiseaseMatch {
  int totalRules = 0;
  int satisfiedRules = 0;
  int matchedAntecedents = 0;
  int totalAntecedents = 0;
  final Set<String> matchedSymptoms = {};

  double get ruleSatisfaction => totalRules == 0 ? 0 : satisfiedRules / totalRules;
  double get antecedentCoverage => totalAntecedents == 0 ? 0 : matchedAntecedents / totalAntecedents;
  double get finalScore => (ruleSatisfaction * 0.6) + (antecedentCoverage * 0.4);
}

// ------------------------------- SCREENS -------------------------------
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_hospital, size: 96, color: Colors.white),
                  const SizedBox(height: 24),
                  Text(
                    'Sistem Pakar\nDiagnosa Penyakit Anak',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Jawab pertanyaan gejala secara sederhana (Ya/Tidak) untuk memperoleh dugaan dini.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text('Get Started'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(),
          const SizedBox(height: 16),
          _MenuCard(
            icon: Icons.assignment_turned_in,
            title: 'Diagnosis Penyakit Anak',
            subtitle: 'Mulai jawaban Ya/Tidak dari 38 gejala',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiagnosisFormScreen(),
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
            subtitle: 'Metode Forward Chaining dan sumber pengetahuan',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.tips_and_updates,
            title: 'Tips Kesehatan Anak',
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
          const Icon(Icons.child_care, size: 48),
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
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
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

// -------------------------- Diagnosis Form --------------------------
class DiagnosisFormScreen extends StatefulWidget {
  DiagnosisFormScreen({super.key});

  final engine = ForwardChainingEngine(_knowledgeBase);

  @override
  State<DiagnosisFormScreen> createState() => _DiagnosisFormScreenState();
}

class _DiagnosisFormScreenState extends State<DiagnosisFormScreen> {
  int _index = 0;
  final Set<String> _facts = {};
  final List<_AnswerLog> _answers = [];

  void _answer(bool yes) {
    final current = symptoms[_index];
    if (yes) _facts.add(current.code); else _facts.remove(current.code);
    _answers.add(_AnswerLog(code: current.code, text: current.question, yes: yes));

    if (_index < symptoms.length - 1) {
      setState(() => _index += 1);
    } else {
      _finish();
    }
  }

  void _finish() {
    final results = widget.engine.infer(_facts);
    // Rank by score
    final ranked = results.entries.toList()
      ..sort((a, b) => b.value.finalScore.compareTo(a.value.finalScore));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          facts: _facts,
          answers: _answers,
          ranked: ranked,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = symptoms[_index];
    final progress = (_index + 1) / symptoms.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Gejala (Ya/Tidak)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text('Pertanyaan ${_index + 1} dari ${symptoms.length}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black54)),
            const SizedBox(height: 12),
            _QuestionCard(text: s.question),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Tidak'),
                    onPressed: () => _answer(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Ya'),
                    onPressed: () => _answer(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String text;
  const _QuestionCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.help_outline, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}

class _AnswerLog {
  final String code;
  final String text;
  final bool yes;
  const _AnswerLog({required this.code, required this.text, required this.yes});
}

// ------------------------------- Results -------------------------------
class ResultScreen extends StatelessWidget {
  final Set<String> facts;
  final List<_AnswerLog> answers;
  final List<MapEntry<String, DiseaseMatch>> ranked;
  const ResultScreen({super.key, required this.facts, required this.answers, required this.ranked});

  @override
  Widget build(BuildContext context) {
    final best = ranked.isNotEmpty ? ranked.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Diagnosis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (best != null) _BestDiagnosisCard(entry: best),
          const SizedBox(height: 16),
          Text('Peringkat Diagnosa', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...ranked.map((e) => _RankTile(entry: e)),
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
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            ),
          ),
        ],
      ),
    );
  }
}

class _BestDiagnosisCard extends StatelessWidget {
  final MapEntry<String, DiseaseMatch> entry;
  const _BestDiagnosisCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final dz = diseases.firstWhere((d) => d.code == entry.key);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dugaan Utama', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.local_hospital, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dz.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text('${(entry.value.finalScore * 100).toStringAsFixed(1)}% kecocokan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => _DiseaseDetailSheet(disease: dz, match: entry.value),
                ),
                child: const Text('Detail'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankTile extends StatelessWidget {
  final MapEntry<String, DiseaseMatch> entry;
  const _RankTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final dz = diseases.firstWhere((d) => d.code == entry.key);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.assignment),
        title: Text(dz.name),
        subtitle: Text('Skor: ${(entry.value.finalScore * 100).toStringAsFixed(1)}%  ·  Aturan terpenuhi: ${entry.value.satisfiedRules}/${entry.value.totalRules}'),
        trailing: TextButton(
          child: const Text('Info'),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => _DiseaseDetailSheet(disease: dz, match: entry.value),
          ),
        ),
      ),
    );
  }
}

class _DiseaseDetailSheet extends StatelessWidget {
  final Disease disease;
  final DiseaseMatch match;
  const _DiseaseDetailSheet({required this.disease, required this.match});

  @override
  Widget build(BuildContext context) {
    final matched = match.matchedSymptoms.toList();
    matched.sort();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 48,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
              ),
            ),
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
            if (matched.isEmpty)
              const Text('Belum ada gejala yang cocok dengan aturan untuk penyakit ini.'),
            if (matched.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: matched
                    .map((code) => Chip(label: Text('$code – ${symptoms.firstWhere((s) => s.code == code).question.replaceFirst('Apakah ', '').replaceAll('?', '')}')))
                    .toList(),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------- History -------------------------------
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo, we don’t persist; integrate SharedPreferences/SQLite as needed.
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: const Center(
        child: Text('Belum ada riwayat tersimpan. (Integrasikan SharedPreferences/SQLite)'),
      ),
    );
  }
}

// ------------------------------- Tips -------------------------------
class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Pantau suhu tubuh, gunakan termometer digital.',
      'Cukupkan asupan cairan, terutama saat demam/diare.',
      'Kenali tanda bahaya: kejang, sesak berat, penurunan kesadaran.',
      'Lengkapi imunisasi dan konsultasi rutin ke dokter anak.',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tips Kesehatan Anak')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(tips[i]),
          ),
        ),
      ),
    );
  }
}

// ------------------------------- About -------------------------------
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metode', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Aplikasi ini menggunakan pendekatan Sistem Pakar dengan mesin inferensi \"Forward Chaining\". '
              'Pengguna memasukkan fakta (gejala), mesin mencocokkan dengan aturan, '
              'lalu menyajikan dugaan penyakit secara berperingkat.'
            ),
            const SizedBox(height: 16),
            Text('Disclaimer', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Hasil bukan diagnosis medis final dan tidak menggantikan konsultasi dokter. '
              'Gunakan sebagai skrining/edukasi. Bila ada tanda bahaya, segera ke fasilitas kesehatan.'
            ),
          ],
        ),
      ),
    );
  }
}
