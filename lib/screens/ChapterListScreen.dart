import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ChapterContentScreen.dart';

class ChapterListScreen extends StatelessWidget {
  final String storyId;

  const ChapterListScreen({super.key, required this.storyId});

  Future<List<Map<String, dynamic>>> fetchChapters() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('stories')
        .doc(storyId)
        .collection('chapters')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'title': doc['title'],
        'contents': doc['contents'],
      };
    }).toList();
  }

  Future<void> addToReadingHistory(String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final historyRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reading_history');

    await historyRef.add({
      'title': title,
      'type': 'Truyện',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color pinkColor = Colors.pink.shade100;
    final Color deepPink = Colors.pink.shade400;

    return Scaffold(
      appBar: AppBar(
        title: const Text("📖 Danh sách chương"),
        backgroundColor: deepPink,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: fetchChapters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("❌ Lỗi khi tải chương"));
          }

          final chapters = snapshot.data;
          if (chapters == null || chapters.isEmpty) {
            return const Center(child: Text("📭 Chưa có chương nào"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chapters.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              final title = chapter['title'];

              return Material(
                elevation: 2,
                color: pinkColor,
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  leading: CircleAvatar(
                    backgroundColor: deepPink,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.menu_book_rounded, color: Colors.pinkAccent),
                  onTap: () async {
                    await addToReadingHistory(title); // 💾 Thêm lịch sử
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChapterContentScreen(
                          title: chapter['title'],
                          content: chapter['contents'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
