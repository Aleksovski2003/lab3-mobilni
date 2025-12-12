import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> addFavorite(String mealId, String mealName, String mealThumb) async {
    await _firestore.collection('favorites').doc(mealId).set({
      'mealId': mealId,
      'mealName': mealName,
      'mealThumb': mealThumb,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }


  Future<void> removeFavorite(String mealId) async {
    await _firestore.collection('favorites').doc(mealId).delete();
  }

  Future<bool> isFavorite(String mealId) async {
    final doc = await _firestore.collection('favorites').doc(mealId).get();
    return doc.exists;
  }

  Stream<QuerySnapshot> getFavorites() {
    return _firestore
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}