// ========================= lib/core/history.dart =========================
class HistoryEntry {
  final String domainCode;
  final String domainTitle;
  final String bestDiseaseCode;
  final String bestDiseaseName;
  final double score;
  final List<String> matchedSymptoms;
  final DateTime time;

  HistoryEntry({
    required this.domainCode,
    required this.domainTitle,
    required this.bestDiseaseCode,
    required this.bestDiseaseName,
    required this.score,
    required this.matchedSymptoms,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'domainCode': domainCode,
        'domainTitle': domainTitle,
        'bestDiseaseCode': bestDiseaseCode,
        'bestDiseaseName': bestDiseaseName,
        'score': score,
        'matchedSymptoms': matchedSymptoms,
        'time': time.toIso8601String(),
      };

  static HistoryEntry fromJson(Map<String, dynamic> j) => HistoryEntry(
        domainCode: j['domainCode'],
        domainTitle: j['domainTitle'],
        bestDiseaseCode: j['bestDiseaseCode'],
        bestDiseaseName: j['bestDiseaseName'],
        score: (j['score'] as num).toDouble(),
        matchedSymptoms: (j['matchedSymptoms'] as List).cast<String>(),
        time: DateTime.parse(j['time']),
      );
}