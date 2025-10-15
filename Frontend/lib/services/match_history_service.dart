import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/match_models.dart';

class MatchHistoryService {
  static const String _historyKey = 'match_history';
  static const int _maxHistorySize = 50;

  Future<List<Match>> getMatchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      return historyJson
          .map((json) => Match.fromJson(jsonDecode(json)))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveMatch(Match match) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      // Add new match at the beginning
      historyJson.insert(0, jsonEncode(match.toJson()));

      // Keep only the last N matches
      if (historyJson.length > _maxHistorySize) {
        historyJson.removeRange(_maxHistorySize, historyJson.length);
      }

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> deleteMatch(String matchId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      historyJson.removeWhere((json) {
        final match = Match.fromJson(jsonDecode(json));
        return match.id == matchId;
      });

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<Match?> getMatchById(String matchId) async {
    try {
      final history = await getMatchHistory();
      return history.firstWhere((match) => match.id == matchId);
    } catch (e) {
      return null;
    }
  }
}
