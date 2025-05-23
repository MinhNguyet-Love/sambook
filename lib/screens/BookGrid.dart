import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'BookChapterListScreen.dart';

class BookGrid extends StatefulWidget {
  const BookGrid({super.key});

  @override
  State<BookGrid> createState() => _BookGridState();
}

class _BookGridState extends State<BookGrid> {
  String selectedCategory = 'Tất cả';
  final List<String> categories = [
    'Tất cả',
    'Sách tổng hợp',
    'Sách khoa học',
    'Sách kinh doanh',
    'Sách tình yêu',
  ];

  Future<List<Map<String, dynamic>>> fetchBooks(String category) async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('books');

    if (category != 'Tất cả') {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'],
        'author': data['author'],
        'coverUrl': data['coverUrl'],
        'rating': (data['rating'] is num) ? (data['rating'] as num).toDouble() : 4.0,
      };
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lọc thể loại (cuộn ngang)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue.shade50 : Colors.white,
                    side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.pink : Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Danh sách sách dạng PageView
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchBooks(selectedCategory),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("❌ Lỗi khi tải sách"));
              }

              final books = snapshot.data;
              if (books == null || books.isEmpty) {
                return const Center(child: Text("📭 Không có sách nào"));
              }

              return PageView.builder(
                itemCount: books.length,
                controller: PageController(viewportFraction: 0.85),
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookChapterListScreen(bookId: book['id']),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                book['coverUrl'],
                                height: 400,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Text(
                                    book['title'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  RatingBarIndicator(
                                    rating: book['rating'],
                                    itemBuilder: (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                                    itemCount: 5,
                                    itemSize: 24,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
