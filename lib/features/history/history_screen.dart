// ==================== lib/features/history/history_screen.dart ====================
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/history_storage.dart';
import '../../core/history.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<HistoryEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = HistoryStorage.load();
  }

  Future<void> _refresh() async {
    setState(() => _future = HistoryStorage.load());
  }

  Future<void> _clear() async {
    await HistoryStorage.clear();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          IconButton(onPressed: _clear, icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: FutureBuilder<List<HistoryEntry>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada riwayat tersimpan.'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final it = items[i];
                final time = DateFormat('dd MMM yyyy, HH:mm').format(it.time);
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text('${it.bestDiseaseName}  •  ${(it.score * 100).toStringAsFixed(1)}%'),
                    subtitle: Text('${it.domainTitle}  •  $time'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => _HistoryDetail(entry: it),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _HistoryDetail extends StatelessWidget {
  final HistoryEntry entry;
  const _HistoryDetail({required this.entry});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(height: 4, width: 48, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)))),
          Text(entry.bestDiseaseName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text('Skor ${(entry.score * 100).toStringAsFixed(1)}%  •  ${entry.domainTitle}'),
          const SizedBox(height: 12),
          Text('Gejala terpenuhi', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Wrap(spacing: 8, runSpacing: 8, children: entry.matchedSymptoms.map((e) => Chip(label: Text(e))).toList()),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}