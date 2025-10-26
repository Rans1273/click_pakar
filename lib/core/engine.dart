// ========================= lib/core/engine.dart =========================
import 'models.dart';

class ForwardChainingEngine {
  final List<Rule> rules;
  ForwardChainingEngine(this.rules);

  Map<String, DiseaseMatch> infer(Set<String> facts) {
    final Map<String, DiseaseMatch> scores = {};
    for (final r in rules) {
      final matched = r.requiredSymptoms.intersection(facts).length;
      final total = r.requiredSymptoms.length;
      final ok = matched == total;

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