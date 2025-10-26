// ============== lib/features/diagnosis/diagnosis_screen.dart ==============
import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/engine.dart';
import 'result_screen.dart';

class DiagnosisFormScreen extends StatefulWidget {
  final DomainConfig domain;
  const DiagnosisFormScreen({super.key, required this.domain});

  @override
  State<DiagnosisFormScreen> createState() => _DiagnosisFormScreenState();
}

class _DiagnosisFormScreenState extends State<DiagnosisFormScreen> {
  int _index = 0;
  final Set<String> _facts = {};
  final List<_AnswerLog> _answers = [];

  void _answer(bool yes) {
    final current = widget.domain.symptoms[_index];
    if (yes) _facts.add(current.code); else _facts.remove(current.code);
    _answers.add(_AnswerLog(code: current.code, text: current.question, yes: yes));

    if (_index < widget.domain.symptoms.length - 1) {
      setState(() => _index += 1);
    } else {
      _finish();
    }
  }

  void _finish() {
    final engine = ForwardChainingEngine(widget.domain.rules);
    final results = engine.infer(_facts);
    final ranked = results.entries.toList()
      ..sort((a, b) => b.value.finalScore.compareTo(a.value.finalScore));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          domain: widget.domain,
          facts: _facts,
          answers: _answers,
          ranked: ranked,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.domain.symptoms[_index];
    final progress = (_index + 1) / widget.domain.symptoms.length;

    return Scaffold(
      appBar: AppBar(title: Text('Form Gejala (${widget.domain.code})')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text('Pertanyaan ${_index + 1} dari ${widget.domain.symptoms.length}',
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
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
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