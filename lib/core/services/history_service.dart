import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class HistoryService {
  HistoryService._();
  static final HistoryService instance = HistoryService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => AuthService.instance.currentUser?.uid;

  /// Retrieves recent searches for the current user
  Stream<List<Map<String, dynamic>>> getRecentSearches() {
    if (_uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(_uid)
        .collection('searches')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  /// Adds a new search to the user's history
  Future<void> addSearch(String query) async {
    if (_uid == null) return;

    try {
      await _db.collection('users').doc(_uid).collection('searches').add({
        'query': query,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding search: $e');
    }
  }

  /// Clears all recent searches
  Future<void> clearRecentSearches() async {
    if (_uid == null) return;

    try {
      final snapshot = await _db
          .collection('users')
          .doc(_uid)
          .collection('searches')
          .get();

      final batch = _db.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing searches: $e');
    }
  }

  /// Save a chat message to history
  Future<void> saveChatMessage(String chatId, Map<String, dynamic> messageData) async {
    if (_uid == null) return;

    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        ...messageData,
        'serverTimestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving chat message: $e');
    }
  }
}
