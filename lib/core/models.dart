// ========================= lib/core/models.dart =========================
class Symptom {
  final String code;
  final String question;
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

class Rule {
  final String diseaseCode;
  final Set<String> requiredSymptoms; // AND
  const Rule({required this.diseaseCode, required this.requiredSymptoms});
}

/// Konfigurasi domain untuk dipakai ulang oleh layar diagnosis
class DomainConfig {
  final String code; // 'PED' atau 'PRG'
  final String title;
  final List<Symptom> symptoms;
  final List<Disease> diseases;
  final List<Rule> rules;
  const DomainConfig({
    required this.code,
    required this.title,
    required this.symptoms,
    required this.diseases,
    required this.rules,
  });
}
