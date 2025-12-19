import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

/// Firebase service for managing both Firestore and Realtime Database
/// - Firestore: History/Logs (collection: Beltran_SnackPack_Logs)
/// - Realtime DB: Live/Latest prediction
class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Use the specific Realtime Database URL for asia-southeast1 region
  static final FirebaseDatabase _realtimeDB = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
        'https://beltran-snackpack-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  /// Save prediction to both Firestore (history) and Realtime DB (live)
  static Future<void> savePrediction({
    required String classType,
    required double accuracyRate,
    required String category,
  }) async {
    final timestamp = DateTime.now();

    // Save to both databases in parallel
    await Future.wait([
      _saveToFirestore(
        classType: classType,
        accuracyRate: accuracyRate,
        category: category,
        timestamp: timestamp,
      ),
      _saveToRealtimeDB(
        classType: classType,
        accuracyRate: accuracyRate,
        category: category,
        timestamp: timestamp,
      ),
    ]);
  }

  /// Save to Firestore for history/analytics
  static Future<void> _saveToFirestore({
    required String classType,
    required double accuracyRate,
    required String category,
    required DateTime timestamp,
  }) async {
    try {
      await _firestore.collection('Beltran_SnackPack_Logs').add({
        'ClassType': classType,
        'Accuracy_Rate': (accuracyRate * 100).round(), // Convert to percentage
        'Category': category,
        'Time': Timestamp.fromDate(timestamp),
      });
      print('✅ Saved to Firestore: $classType');
    } catch (e) {
      print('❌ Error saving to Firestore: $e');
      rethrow;
    }
  }

  /// Save to Realtime Database for live/latest prediction
  static Future<void> _saveToRealtimeDB({
    required String classType,
    required double accuracyRate,
    required String category,
    required DateTime timestamp,
  }) async {
    try {
      final ref = _realtimeDB.ref('latest_prediction');
      await ref.set({
        'ClassType': classType,
        'Accuracy_Rate': (accuracyRate * 100).round(), // Convert to percentage
        'Category': category,
        'Time': timestamp.toIso8601String(),
      });
      print('✅ Saved to Realtime DB: $classType');
    } catch (e) {
      print('❌ Error saving to Realtime DB: $e');
      rethrow;
    }
  }

  /// Get the latest prediction from Realtime DB (for live display)
  static Future<Map<String, dynamic>?> getLatestPrediction() async {
    try {
      final ref = _realtimeDB.ref('latest_prediction');
      final snapshot = await ref.get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('❌ Error getting latest prediction: $e');
      return null;
    }
  }

  /// Stream latest prediction for real-time updates
  static Stream<Map<String, dynamic>?> streamLatestPrediction() {
    final ref = _realtimeDB.ref('latest_prediction');
    return ref.onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }

  /// Get history from Firestore
  static Future<List<Map<String, dynamic>>> getHistory({int limit = 50}) async {
    try {
      final snapshot = await _firestore
          .collection('Beltran_SnackPack_Logs')
          .orderBy('Time', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => {
                ...doc.data(),
                'id': doc.id,
              })
          .toList();
    } catch (e) {
      print('❌ Error getting history: $e');
      return [];
    }
  }
}
