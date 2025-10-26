// ===================== lib/services/history_storage.dart =====================
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/history.dart';

class HistoryStorage {
  static const _key = 'diagnosis_history_v1';

  static Future<List<HistoryEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List list = jsonDecode(raw);
    return list.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> save(List<HistoryEntry> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  static Future<void> add(HistoryEntry entry) async {
    final items = await load();
    items.insert(0, entry);
    await save(items);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
