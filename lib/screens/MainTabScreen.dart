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
    final user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "SamBook 📚",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 4,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            if (user != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: PopupMenuButton<int>(
                  offset: const Offset(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 1) {
                      _signOut(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: user.photoURL != null
                                  ? NetworkImage(user.photoURL!)
                                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              user.displayName ?? 'Không có tên',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              user.email ?? 'Không có email',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.exit_to_app, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Đăng xuất'),
                        ],
                      ),
                    ),
                  ],
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                ),
              ),
          ],
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
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Lịch sử'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Trang Admin'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Thông tin'),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'SamBook',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2025 SamBook Team',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Đăng xuất'),
                onTap: () => _signOut(context),
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
