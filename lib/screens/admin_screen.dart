import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _coverUrlController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _chapterTitleController = TextEditingController();
  final TextEditingController _chapterContentController = TextEditingController();

  String _selectedType = 'truyen';
  String _selectedCategory = 'Tổng hợp';

  final List<String> _types = ['truyen', 'sach'];
  final List<String> _categories = [
    'Tổng hợp',
    'Hài hước',
    'Tình cảm',
    'Kinh dị',
    'Giáo dục',
    'Kỹ năng sống',
  ];

  void _saveToFirestore() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Chọn collection phù hợp
        String collectionName = _selectedType == 'sach' ? 'books' : 'stories';

        // Lưu thông tin truyện/sách
        var docRef = await FirebaseFirestore.instance.collection(collectionName).add({
          'title': _titleController.text,
          'author': _authorController.text,
          'coverUrl': _coverUrlController.text,
          'rating': double.tryParse(_ratingController.text) ?? 4.5,
          'type': _selectedType,
          'category': _selectedCategory,
          'createdAt': Timestamp.now(),
        });

        // Lưu chương đầu tiên
        await docRef.collection('chapters').add({
          'title': _chapterTitleController.text.isEmpty ? 'Chương 1' : _chapterTitleController.text,
          'order': 1,
          'contents': _chapterContentController.text.isEmpty ? 'Nội dung chương 1' : _chapterContentController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm thành công!')),
        );

        print("Dữ liệu đã được lưu vào Firestore.");

        _titleController.clear();
        _authorController.clear();
        _coverUrlController.clear();
        _ratingController.clear();
        _chapterTitleController.clear();
        _chapterContentController.clear();
      } catch (e) {
        print("Lỗi khi lưu dữ liệu vào Firestore: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tên truyện / sách'),
                validator: (value) => value!.isEmpty ? 'Không được để trống tiêu đề' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Tác giả'),
                validator: (value) => value!.isEmpty ? 'Không được để trống tác giả' : null,
              ),
              TextFormField(
                controller: _coverUrlController,
                decoration: const InputDecoration(labelText: 'URL ảnh bìa'),
                validator: (value) => value!.isEmpty ? 'Không được để trống ảnh bìa' : null,
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Đánh giá (vd: 4.5)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _chapterTitleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề chương'),
              ),
              TextFormField(
                controller: _chapterContentController,
                decoration: const InputDecoration(labelText: 'Nội dung chương'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Loại (truyện/sách)'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Phân loại'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveToFirestore,
                child: const Text('Thêm vào Firebase'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
