import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addToReadingHistory(String title, String type) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('reading_history');

  await docRef.add({
    'title': title,
    'type': type,
  });
}
