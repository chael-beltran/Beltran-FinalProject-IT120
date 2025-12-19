import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_history_item.dart';

/// Service for managing scan history with persistent storage
class HistoryService {
  static const String _historyKey = 'scan_history';
  static List<ScanHistoryItem> _historyItems = [];
  static bool _isInitialized = false;
  static SharedPreferences? _prefs;

  /// Initialize the service and load saved history
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      final String? historyJson = _prefs?.getString(_historyKey);

      if (historyJson != null) {
        try {
          final List<dynamic> decoded = jsonDecode(historyJson);
          _historyItems =
              decoded.map((item) => ScanHistoryItem.fromJson(item)).toList();
        } catch (e) {
          debugPrint('Error parsing history: $e');
          _historyItems = [];
        }
      }
    } catch (e) {
      debugPrint('Error initializing HistoryService: $e');
    }

    _isInitialized = true;
  }

  /// Save history to persistent storage (non-blocking)
  static void _saveToStorageAsync() {
    // Run in background, don't await
    Future(() async {
      try {
        if (_prefs == null) {
          _prefs = await SharedPreferences.getInstance();
        }
        final String historyJson = jsonEncode(
          _historyItems.map((item) => item.toJson()).toList(),
        );
        await _prefs?.setString(_historyKey, historyJson);
      } catch (e) {
        debugPrint('Error saving to storage: $e');
      }
    });
  }

  /// Check if a scan result is already saved (by image path)
  static bool isAlreadySaved(String imagePath) {
    return _historyItems.any((item) => item.imagePath == imagePath);
  }

  /// Add a new scan to history (synchronous for UI, async storage in background)
  /// Returns true if added, false if already exists
  static bool addScan({
    required String className,
    required double confidence,
    required String category,
    String? imagePath,
    List<Map<String, dynamic>>? allPredictions,
  }) {
    // Check for duplicates based on image path
    if (imagePath != null && isAlreadySaved(imagePath)) {
      return false; // Already saved
    }

    final item = ScanHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      className: className,
      confidence: confidence,
      scanDate: DateTime.now(),
      imagePath: imagePath,
      category: category,
      allPredictions: allPredictions,
    );

    _historyItems.insert(0, item); // Add to beginning (newest first)

    // Save to storage in background (don't block UI)
    _saveToStorageAsync();

    return true; // Successfully added
  }

  /// Get all history items (newest first)
  static List<ScanHistoryItem> getAll() {
    return List.from(_historyItems);
  }

  /// Get total number of scans
  static int get totalScans => _historyItems.length;

  /// Calculate average accuracy/confidence
  static double get averageAccuracy {
    if (_historyItems.isEmpty) return 0.0;
    final total = _historyItems.fold<double>(
      0.0,
      (sum, item) => sum + item.confidence,
    );
    return total / _historyItems.length;
  }

  /// Get average accuracy as percentage string
  static String get averageAccuracyPercent {
    return '${(averageAccuracy * 100).toStringAsFixed(0)}%';
  }

  /// Clear all history
  static void clearAll() {
    _historyItems.clear();
    _saveToStorageAsync();
  }

  /// Delete a specific item
  static void delete(String id) {
    _historyItems.removeWhere((item) => item.id == id);
    _saveToStorageAsync();
  }

  /// Check if history is empty
  static bool get isEmpty => _historyItems.isEmpty;
}
