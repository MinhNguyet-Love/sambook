import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import 'BookGrid.dart';
import 'StoryGrid.dart';
import 'history_screen.dart';
import 'admin_screen.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng xuất thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "SamBook 📚",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 4, // Thêm chút bóng đổ để AppBar nổi bật
          bottom: const TabBar(
            indicatorColor: Colors.pink,
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Truyện hay", icon: Icon(Icons.menu_book)),
              Tab(text: "Sách hay", icon: Icon(Icons.book)),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.pink),
                child: Text(
                  'SamBook Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Trang chủ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Lịch sử'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.pink[300], // Đổi màu icon Admin nhẹ nhàng hơn
                ),
                title: const Text('Trang Admin'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Thông tin'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'SamBook',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2025 SamBook Team',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Thoát'),
                onTap: () {
                  _signOut(context);
                },
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StoryGrid(type: "truyen"),
            BookGrid(),
          ],
        ),
      ),
    );
  }
}
